using CentralMusicAPI.Entities;

namespace CentralMusicAPI.Models.Users
{
    public class UserUpdateProfile
    {
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public Address Localization { get; set; }
    }
}
