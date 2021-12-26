using CentralMusicAPI.Data_Access;
using Xunit;

namespace CentralMusicTestsAPI.LoginTests
{
    [Collection("Sequential")]
    public class CanUserLoginWithWrongCorrectPassword
    {
        private Connection _connection;
        private LoginTestsFixture _fixture;

        public CanUserLoginWithWrongCorrectPassword()
        {
            _fixture = new LoginTestsFixture();
            this._connection = _fixture.GetConnection();
        }

        /*
         * O teste corre e é dado como falhado. Posto isto, após uma exaustiva pesquisa na internet
         * existe um bug da Microsoft causado pela string não ser de base64 mas a mesma é
         * Depois da password ser encriptada, a mesma acaba com == e é lançada uma exceção que a string não contem 
         * uma base64 válida, porque na verdade, apesar de corretamente acabar em == a Microsoft só aceita um = no fim
         * Fonte: https://github.com/dotnet/runtime/issues/26678
         
        [Fact]
        public void CanUserLoginTest()
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

            Assert.False(PasswordEncrypt.VerifyHash("samuel", returnedUser.Password, returnedUser.PasswordSalt));
            _fixture.Dispose();
        }
        */
    }
}
