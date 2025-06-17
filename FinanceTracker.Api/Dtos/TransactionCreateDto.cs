
using System.ComponentModel.DataAnnotations;

namespace FinanceTracker.Api.Dtos
{
    public class TransactionCreateDto
    {
        [Required, MaxLength(255)]
        public string Description { get; set; } = string.Empty;

        [Required]
        public decimal Amount { get; set; }

        public DateTime? TransactionDate { get; set; } 

        [Required]
        public bool? IsExpense { get; set; }

        [Required]
        public int CategoryId { get; set; }
    }
}