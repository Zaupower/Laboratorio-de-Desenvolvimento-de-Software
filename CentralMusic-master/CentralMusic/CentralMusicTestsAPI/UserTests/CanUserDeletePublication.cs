using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Entities.Enums;
using CentralMusicAPI.Models;
using Xunit;

namespace CentralMusicTestsAPI.UserTests
{
    [Collection("Sequential")]
    public class CanUserDeletePublication
    {
        private Connection _connection;
        private UserTestsFixture _fixture;

        public CanUserDeletePublication()
        {
            _fixture = new UserTestsFixture();
            this._connection = _fixture.GetConnection();
        }

        [Fact]
        public void CanDeletePublication()
        {
            UserDAO userDAO = new UserDAO(_connection);
            User testUser1 = new User();

            testUser1.Email = "samuel@gmail.com";
            testUser1.Password = "123";
            testUser1.FirstName = "Samuel";
            testUser1.LastName = "Cunha";
            testUser1.Password = "123";
            testUser1.Image = "ImageLocation";
            Address adr = new Address();
            adr.PostalCode = "4615-423";
            adr.Street = "Rua de Real";
            adr.StreetNumber = 55;
            adr.District = "Porto";
            adr.Country = "Portugal";
            testUser1.Localization = adr.ToString();

            //User 1 a utilizar
            User returnedUser = userDAO.Create(testUser1);

            Publication p = new Publication();

            p.Tittle = "Um Piana Novo Novo Novo";
            p.Description = "muito muito muito muito muito novo com cordas";
            p.Tradable = true;
            p.Category = Categories.Cordas;
            p.ImagePath = "Image/Path";
            p.InitialPrice = 20;
            p.InstrumentCondition = Condition.BomEstado;
            p.UtilizadorId = returnedUser.Id;
            Address adrP = new Address();
            adrP.PostalCode = "4615-423";
            adrP.Street = "Rua de Real";
            adrP.StreetNumber = 55;
            adrP.District = "Porto";
            adrP.Country = "Portugal";
            p.UserAddress = adrP;


            PublicationDAO pDAO = new PublicationDAO(_connection);
            Publication returnedP = pDAO.Create(p);
            //bool deleted = pDAO.Delete(returnedP.Id);
            bool deleted = userDAO.DeletePublication(returnedP.Id);
            //Publication afterCreate = pDAO.FindById(returnedP.Id);
            Assert.True(deleted);
        }
    }
}
