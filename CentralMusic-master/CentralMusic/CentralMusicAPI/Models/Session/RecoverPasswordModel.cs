using System.ComponentModel.DataAnnotations;

namespace CentralMusicAPI.Models.Session
{
    public class RecoverPasswordModel
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; }
        [Required]
        [DataType(DataType.Password)]
        public string Password { get; set; }
        [DataType(DataType.Password)]
        [Display(Name = "Confirme a password")]
        [Compare("Password", ErrorMessage = "As passwords não combinam")]
        public string ConfirmPassword { get; set; }
        [Required]
        public string Token { get; set; }
    }
}
