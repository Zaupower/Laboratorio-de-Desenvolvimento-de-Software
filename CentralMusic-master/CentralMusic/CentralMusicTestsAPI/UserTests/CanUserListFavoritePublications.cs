using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Entities.Enums;
using CentralMusicAPI.Models;
using System.Collections.Generic;
using System.Linq;
using Xunit;

namespace CentralMusicTestsAPI.UserTests
{
    [Collection("Sequential")]
    public class CanUserListFavoritePublications
    {
        private Connection _connection;
        private UserTestsFixture _fixture;

        public CanUserListFavoritePublications()
        {
            _fixture = new UserTestsFixture();
            this._connection = _fixture.GetConnection();
        }

        [Fact]
        public void CanUserListFavoritePublicationsTest()
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

            User returnedUser = UserDAO.Create(testUser);

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

            pDAO.AddPublicationToFavorites(returnedUser.Id, returnedP.Id);
            List<Publication> favoritePublications = UserDAO.GetPublicationFromFavorites(returnedUser.Id).ToList();

            Assert.Equal(returnedP.Id, favoritePublications.Find(a => a.Id == returnedP.Id).Id);
        }
    }
}
