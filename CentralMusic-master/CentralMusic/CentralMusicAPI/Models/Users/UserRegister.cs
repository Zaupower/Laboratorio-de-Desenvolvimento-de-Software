using CentralMusicAPI.Entities;
using System.ComponentModel.DataAnnotations;

namespace CentralMusicAPI.Models.Users
{
    /// <summary>
    /// Modelo usado por um utilizador
    /// para se resgistar com os seus dados pessoais
    /// </summary>
    public class UserRegister
    {
        [EmailAddress]
        [Required]
        public string Email { get; set; }
        [Required]
        public string Password { get; set; }
        [Required]
        public string FirstName { get; set; }
        [Required]
        public string LastName { get; set; }
        [Required]
        public Address Localization { get; set; }
    }
}
