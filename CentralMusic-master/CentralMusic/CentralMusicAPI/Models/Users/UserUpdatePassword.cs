using System.ComponentModel.DataAnnotations;

namespace CentralMusicAPI.Models.Users
{
    public class UserUpdatePassword
    {
        [Required]
        public string ActualPassword { get; set; }
        [Required]
        public string NewPassword { get; set; }
    }
}
