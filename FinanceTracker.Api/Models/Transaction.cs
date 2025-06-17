
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FinanceTracker.Api.Models
{
    public class Transaction
    {
        public int Id { get; set; }

        [Required, MaxLength(255)]
        public string Description { get; set; } = string.Empty;

        [Required, Column(TypeName = "decimal(10, 2)")]
        public decimal Amount { get; set; }
        public DateTime TransactionDate { get; set; } = DateTime.UtcNow;
        public bool IsExpense { get; set; }

        // Foreign key to Category
        public int CategoryId { get; set; }
        public Category Category { get; set; } = null!;

        // Each transaction belongs to a specific user.
        public int UserId { get; set; }
        public User User { get; set; } = null!;
    }
}