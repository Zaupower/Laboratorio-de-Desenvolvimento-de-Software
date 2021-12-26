using System.ComponentModel.DataAnnotations;

namespace CentralMusicAPI.Models.Session
{
    public class ForgotPasswordModel
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; }
    }
}
