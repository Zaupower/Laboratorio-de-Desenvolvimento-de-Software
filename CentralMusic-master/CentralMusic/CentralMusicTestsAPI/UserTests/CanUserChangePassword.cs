using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Interfaces;
using CentralMusicAPI.Models.Users;
using Xunit;

namespace CentralMusicTestsAPI.UserTests
{
    [Collection("Sequential")]
    public class CanUserChangePassword
    {
        private Connection _connection;
        private UserTestsFixture _fixture;

        public CanUserChangePassword()
        {
            _fixture = new UserTestsFixture();
            this._connection = _fixture.GetConnection();
        }

        [Fact]
        public void CanUserChangePasswordTest()
        {
            IUserDAO<User> UserDAO = new UserDAO(_connection);
            User testUser = new User();

            testUser.Email = "samuelcunha1998@gmail.com";
            testUser.Password = "samuelcunha";
            testUser.FirstName = "Samuel";
            testUser.LastName = "Cunha";
            testUser.Image = "ImageLocation";
            Address adr = new Address();
            adr.PostalCode = "4615-423";
            adr.Street = "Rua de Real";
            adr.StreetNumber = 55;
            adr.District = "Porto";
            adr.Country = "Portugal";
            testUser.Localization = adr.ToString();

            User returnedUser = UserDAO.Create(testUser);

            UserUpdatePassword newPass = new UserUpdatePassword();
            newPass.ActualPassword = "samuelcunha";
            newPass.NewPassword = "samuelcunha123";

            Assert.True(UserDAO.UpdatePassword(newPass, returnedUser.Id));
        }
    }
}
