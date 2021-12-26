using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Helpers;
using CentralMusicAPI.Interfaces;
using CentralMusicAPI.Models.Session;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Xunit;

namespace CentralMusicTestsAPI.UserTests
{
    [Collection("Sequential")]
    public class CanUserRecoverPassword
    {
        private Connection _connection;
        private UserTestsFixture _fixture;

        public CanUserRecoverPassword()
        {
            _fixture = new UserTestsFixture();
            this._connection = _fixture.GetConnection();
        }

        [Fact]
        public void CanUserRecoverPasswordTest()
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

            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes("RQj!O9+Sq|D8XjYa|}kgnk|}ZaQUso)EMF48Fx1~0n~^~%]n|O{NqH(&5RqXbx7");
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Email, testUser.Email.ToString())}),
                Expires = DateTime.UtcNow.AddMinutes(10),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            var tokenString = tokenHandler.WriteToken(token);
            String auxResetToken = tokenString;

            PasswordLost.NewPasswordRequest("samuelcunha1998@gmail.com", auxResetToken);
            LoginDAO loginDAO = new LoginDAO(_connection);
            RecoverPasswordModel recoverPassword = new RecoverPasswordModel();
            recoverPassword.Email = "samuelcunha1998@gmail.com";
            recoverPassword.Password = "samuelcunha123";
            recoverPassword.ConfirmPassword = "samuelcunha123";
            recoverPassword.Token = tokenString;

            Assert.True(loginDAO.RecoverPassword(recoverPassword, returnedUser.Email));

            _fixture.Dispose();


        }
    }
}
