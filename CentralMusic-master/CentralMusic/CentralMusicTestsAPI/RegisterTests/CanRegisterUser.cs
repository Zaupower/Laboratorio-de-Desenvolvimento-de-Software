using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Interfaces;
using Xunit;

namespace CentralMusicTestsAPI.RegisterTests
{
    [Collection("Sequential")]
    public class CanRegisterUser
    {
        private Connection _connection;
        private RegisterTestsFixture _fixture;

        public CanRegisterUser()
        {
            _fixture = new RegisterTestsFixture();
            this._connection = _fixture.GetConnection();
        }

        [Fact]
        public void CanRegisterUserTest()
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

            Assert.Equal(testUser.Email, returnedUser.Email);
            Assert.Equal(testUser.Password, returnedUser.Password);
            Assert.Equal(testUser.FirstName, returnedUser.FirstName);
            Assert.Equal(testUser.LastName, returnedUser.LastName);
            Assert.Equal(testUser.Localization, returnedUser.Localization);
            Assert.Equal(testUser.Image, returnedUser.Image);

            _fixture.Dispose();
        }

    }
}
