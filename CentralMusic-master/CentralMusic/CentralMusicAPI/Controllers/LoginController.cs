using CentralMusicAPI.Configs;
using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Helpers;
using CentralMusicAPI.Interfaces;
using CentralMusicAPI.Models.Exceptions;
using CentralMusicAPI.Models.Session;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace CentralMusicAPI.Controllers
{
    /// <summary>
    /// Controller para as tarefas relacionadas com o modulo de login
    /// </summary>
    [ApiController]
    public class LoginController : Controller
    {
        private readonly string _secret;
        private readonly IConnection _connection;
        public static string auxResetToken { get; set; }
        public static string auxEmail { get; set; }


        /// <summary>
        /// Construtor do Controller
        /// </summary>
        /// <param name="config"></param>
        public LoginController(IOptions<AppSettings> config)
        {
            _connection = new Connection(config);
            _secret = config.Value.Secret;
            _connection.Fetch();
        }

        /// <summary>
        /// Rota para o utilizador realizar o login com o uso de Json Web Tokens
        /// </summary>
        /// <param name="loginModel"></param>
        /// <returns>O token string</returns>
        /// <response code="200">Retorna mensagem de Sucesso com o Token</response>
        /// <response code="400">Bad Request</response>
        [AllowAnonymous]
        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginModel loginModel)
        {
            try
            {
                LoginDAO loginDAO = new LoginDAO(_connection);
                var user = loginDAO.Authenticate(loginModel.Email, loginModel.Password);

                if (user == null)
                {
                    return BadRequest(new ErrorExceptionModel("Username ou password incorreto(s)"));
                }

                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.ASCII.GetBytes(_secret);
                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.SerialNumber, user.Id.ToString()),
                    new Claim(ClaimTypes.Email, user.Email.ToString())}),
                    Expires = DateTime.UtcNow.AddHours(1),
                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                };

                var token = tokenHandler.CreateToken(tokenDescriptor);
                var tokenString = tokenHandler.WriteToken(token);

                return Ok(new { token = tokenString });
            }
            catch (Exception ex)
            {
                return BadRequest(new ErrorExceptionModel(ex.Message));
            }
        }

        /// <summary>
        /// Rota para realizar o pedido de uma nova password
        /// </summary>
        /// <param name="forgotPasswordModel"></param>
        /// <returns>Mensagem de Sucesso ou de Erro</returns>
        /// <response code="200">Retorna mensagem de Sucesso</response>
        /// <response code="400">Bad Request</response>
        [HttpPost("forgotPassword")]
        [AllowAnonymous]
        public IActionResult ForgotPassword(ForgotPasswordModel forgotPasswordModel)
        {
            UserDAO userDAO = new UserDAO(_connection);
            User user = userDAO.FindUserByEmail(forgotPasswordModel.Email);

            if (ModelState.IsValid)
            {
                if (user != null)
                {
                    var tokenHandler = new JwtSecurityTokenHandler();
                    var key = Encoding.ASCII.GetBytes(_secret);
                    var tokenDescriptor = new SecurityTokenDescriptor
                    {
                        Subject = new ClaimsIdentity(new Claim[]
                        {
                            new Claim(ClaimTypes.Email, user.Email.ToString())
                        }),
                        Expires = DateTime.UtcNow.AddMinutes(10),
                        SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                    };

                    var token = tokenHandler.CreateToken(tokenDescriptor);
                    var tokenString = tokenHandler.WriteToken(token);
                    auxResetToken = tokenString;

                    PasswordLost.NewPasswordRequest(forgotPasswordModel.Email, tokenString);
                    auxEmail = forgotPasswordModel.Email;

                    return Ok(new SuccessExceptionModel("Email enviado com sucesso!"));
                }
            }
            return BadRequest(new ErrorExceptionModel("Email não encontrado!"));
        }

        /// <summary>
        /// Rota para mudar a password depois de efetuar o pedido de esquecimento
        /// </summary>
        /// <param name="recoverPasswordModel"></param>
        /// <returns>Mensagem de Sucesso ou de Erro</returns>
        /// <response code="200">Retorna mensagem de Sucesso</response>
        /// <response code="400">Bad Request</response>
        [HttpPost("resetPassword")]
        [AllowAnonymous]
        public IActionResult ResetPassword(RecoverPasswordModel recoverPasswordModel)
        {

            if (ModelState.IsValid)
            {
                UserDAO userDAO = new UserDAO(_connection);
                User user = userDAO.FindUserByEmail(recoverPasswordModel.Email);

                if (user != null && recoverPasswordModel.Email == auxEmail && recoverPasswordModel.Token == auxResetToken)
                {
                    LoginDAO loginDAO = new LoginDAO(_connection);
                    loginDAO.RecoverPassword(recoverPasswordModel, recoverPasswordModel.Email);

                    return Ok(new SuccessExceptionModel("Password alterada com sucesso! Pode fazer login com a password nova"));

                }
                else
                {
                    return BadRequest(new ErrorExceptionModel("O email que introduziu não é o seu ou o token é inválido! Erro!"));
                }
            }

            return BadRequest(new ErrorExceptionModel("Dados não correspondem ao formulário!"));
        }

    }
}
