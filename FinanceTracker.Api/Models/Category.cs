
using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace FinanceTracker.Api.Models
{
    public class Category
    {
        public int Id { get; set; }

        [Required, MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        // Each category belongs to a specific user.
        public int UserId { get; set; }
        [JsonIgnore] // Prevent infinite loops when serializing
        public User User { get; set; } = null!;
    }
}