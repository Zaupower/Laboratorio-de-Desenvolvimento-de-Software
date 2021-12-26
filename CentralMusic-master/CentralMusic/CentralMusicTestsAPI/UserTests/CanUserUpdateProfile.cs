using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Interfaces;
using Xunit;

namespace CentralMusicTestsAPI.UserTests
{
    [Collection("Sequential")]
    public class CanUserUpdateProfile
    {
        private Connection _connection;
        private UserTestsFixture _fixture;

        public CanUserUpdateProfile()
        {
            _fixture = new UserTestsFixture();
            this._connection = _fixture.GetConnection();
        }

        [Fact]
        public void CanEmployerUpdateProfileTest()
        {
            IUserDAO<User> UserDAO = new UserDAO(_connection);
            User testUser = new User();

            testUser.Email = "samuelcunha1998@gmail.com";
            testUser.Password = "samuelcunha";
            testUser.FirstName = "Samuel";
            testUser.LastName = "Cunha";
            testUser.Localization = "Travessa de Figueiredo 44, 4620-784, Torno, Portugal";
            testUser.Image = "imagePath";

            User returnedUser = UserDAO.Create(testUser);

            returnedUser.Email = "samuelcunha@gmail.com";
            returnedUser.Password = "samuelcunha123";
            returnedUser.FirstName = "Samuel";
            returnedUser.LastName = "Cunha";
            returnedUser.Localization = "Travessa de Figueiredo";
            returnedUser.Image = "image";

            User updated = UserDAO.Update(returnedUser, returnedUser.Id);

            Assert.Equal(returnedUser.Email, updated.Email);
            Assert.Equal(returnedUser.Password, updated.Password);
            Assert.Equal(returnedUser.FirstName, updated.FirstName);
            Assert.Equal(returnedUser.LastName, updated.LastName);
            Assert.Equal(returnedUser.Localization, updated.Localization);

            _fixture.Dispose();
        }
    }
}
