
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FinanceTracker.Api.Data;
using FinanceTracker.Api.Models;
using System.Security.Claims;
using FinanceTracker.Api.Dtos;

[Route("api/[controller]")]
[ApiController]
[Authorize] // requires a valid JWT token
public class TransactionsController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public TransactionsController(ApplicationDbContext context)
    {
        _context = context;
    }
    
    
    private int GetUserId() => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Transaction>>> GetTransactions()
    {
        var userId = GetUserId();
        return await _context.Transactions
            .Include(t => t.Category) 
            .Where(t => t.UserId == userId) 
            .OrderByDescending(t => t.TransactionDate)
            .ToListAsync();
    }
    
    
    [HttpGet("categories")]
    public async Task<ActionResult<IEnumerable<Category>>> GetCategories()
    {
        var userId = GetUserId();
        return await _context.Categories
            .Where(c => c.UserId == userId)
            .OrderBy(c => c.Name)
            .ToListAsync();
    }

   
[HttpPost]

public async Task<ActionResult<Transaction>> PostTransaction(TransactionCreateDto requestDto)
{
    var userId = GetUserId();

    
    var categoryExists = await _context.Categories.AnyAsync(c => c.Id == requestDto.CategoryId && c.UserId == userId);
    if (!categoryExists)
    {
        return BadRequest(new { message = "Invalid category." });
    }

    
    var newTransaction = new Transaction
    {
        Description = requestDto.Description,
        Amount = requestDto.Amount,
        IsExpense = requestDto.IsExpense ?? true, 
        TransactionDate = requestDto.TransactionDate ?? DateTime.UtcNow,
        CategoryId = requestDto.CategoryId,
        UserId = userId 
    };

    _context.Transactions.Add(newTransaction);
    await _context.SaveChangesAsync();
    
    // When returning the result, it's good practice to fetch the full object with its Category
    var createdTransaction = await _context.Transactions
        .Include(t => t.Category)
        .FirstOrDefaultAsync(t => t.Id == newTransaction.Id);

    return CreatedAtAction(nameof(GetTransactions), new { id = createdTransaction!.Id }, createdTransaction);
}
    // DELETE: api/transactions/number as 5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteTransaction(int id)
    {
        var userId = GetUserId();
        var transaction = await _context.Transactions
            .FirstOrDefaultAsync(t => t.Id == id && t.UserId == userId); // Ensure user owns the transaction

        if (transaction == null)
        {
            return NotFound();
        }

        _context.Transactions.Remove(transaction);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}