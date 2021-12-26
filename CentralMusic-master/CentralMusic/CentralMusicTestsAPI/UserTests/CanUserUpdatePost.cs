using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Entities.Enums;
using CentralMusicAPI.Models;
using Xunit;

namespace CentralMusicTestsAPI.UserTests
{
    [Collection("Sequential")]
    public class CanUserUpdatePost
    {
        private Connection _connection;
        private UserTestsFixture _fixture;

        public CanUserUpdatePost()
        {
            _fixture = new UserTestsFixture();
            this._connection = _fixture.GetConnection();
        }

        [Fact]
        public void CanUserUpdatePostTest()
        {
            UserDAO UserDAO = new UserDAO(_connection);
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

            //User 1 a utilizar
            User returnedUser = UserDAO.Create(testUser);

            Publication p = new Publication();

            p.Tittle = "Concertina Recanati";
            p.Description = "Como nova pouco uso";
            p.Tradable = true;
            p.Category = Categories.Percusao;
            p.ImagePath = "Image/Path";
            p.InitialPrice = 1900;
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
            Publication afterCreate = pDAO.FindById(returnedP.Id);
            afterCreate.Description = " Uma nova descricao";
            afterCreate.InitialPrice = 1500;


            Publication updatedPublication = new Publication();
            // pDAO.Update(afterCreate);
            UserDAO.UpdatePublication(afterCreate);
            Publication afterUpdate = pDAO.FindById(afterCreate.Id);
            Assert.Equal(afterCreate.Description, afterUpdate.Description);
            Assert.Equal(afterCreate.InitialPrice, afterUpdate.InitialPrice);

        }
    }
}



