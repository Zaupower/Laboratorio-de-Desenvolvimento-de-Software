using System.ComponentModel.DataAnnotations;


namespace CentralMusicAPI.Models.Users
{
    public class UserModel
    {
        [EmailAddress]
        [Required]
        public string Email { get; set; }
    }
}
