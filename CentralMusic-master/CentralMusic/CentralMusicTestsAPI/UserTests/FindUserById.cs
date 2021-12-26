using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Interfaces;
using Xunit;

namespace CentralMusicTestsAPI.UserTests
{
    [Collection("Sequential")]
    public class FindUserById
    {
        private Connection _connection;
        private UserTestsFixture _fixture;

        public FindUserById()
        {
            _fixture = new UserTestsFixture();
            this._connection = _fixture.GetConnection();
        }

        [Fact]
        public void CanFindUserByIdTest()
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

            User user = UserDAO.FindById(returnedUser.Id);

            Assert.NotNull(user);
            Assert.Equal(returnedUser.Id, user.Id);

            _fixture.Dispose();
        }
    }

}
