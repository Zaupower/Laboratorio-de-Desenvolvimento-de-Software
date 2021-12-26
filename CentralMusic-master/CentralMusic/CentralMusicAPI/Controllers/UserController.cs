using AutoMapper;
using CentralMusicAPI.Configs;
using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Helpers;
using CentralMusicAPI.Interfaces;
using CentralMusicAPI.Models;
using CentralMusicAPI.Models.Exceptions;
using CentralMusicAPI.Models.Users;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Security.Claims;

namespace CentralMusicAPI.Controllers
{
    /// <summary>
    /// Controlador com as rotas relativas
    /// as acoes do utilizador
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IConnection _connection;
        private readonly IMapper _mapper;

        /// <summary>
        /// Método construtor da classe UsersController
        /// </summary>
        /// <param name="config">Config com a conexão à BD</param>
        /// <param name="environment">Fornece informações sobre o ambiente de 
        /// hosting na web em que o aplicativo está a ser executado
        /// </param>
        public UserController(IOptions<AppSettings> config, IMapper mapper)
        {
            _mapper = mapper;
            _connection = new Connection(config);
            _connection.Fetch();
        }

        /// <summary>
        /// Registar um utilizador na plataforma
        /// </summary>
        /// <param name="model">Utilizador a ser registado na plataforma</param>
        /// <returns>Utilizador registado</returns>
        /// <response code="200">Utilizador registado</response>
        /// <response code="400">Bad Request</response>
        [HttpPost]
        [Route("register")]
        public ActionResult<UserModel> Create(UserRegister userReg)
        {
            User user = _mapper.Map<User>(userReg);
            IUserDAO<User> UserDAO = new UserDAO(_connection);
            UserModel userModel = _mapper.Map<UserModel>(UserDAO.Create(user));
            return Ok(userModel);
        }

        /// <summary>
        /// Atualiza os dados pessoais do Utilizador
        /// </summary>
        /// <returns>Mensagem de sucesso ou Mensagem de erro</returns>
        /// <response code="200">Update successful</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="403">Forbidden</response>
        /// <response code="400">Bad Request</response>
        [HttpPut]
        [Route("update")]
        [Authorize]
        public IActionResult Update(UserUpdateProfile userUpdate)
        {
            try
            {
                int? id = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);
                if (id == null)
                {
                    return Unauthorized("Sem Autorização ou sem sessão iniciada");
                }

                User user = _mapper.Map<User>(userUpdate);
                UserDAO userDAO = new UserDAO(_connection);
                userDAO.Update(user, (int)id);

                return Ok(new SuccessExceptionModel("Campos Atualizados!"));

            }
            catch (Exception ex)
            {
                return BadRequest(new ErrorExceptionModel(ex.Message));
            }
        }

        /// <summary>
        /// Atualiza a password de um utilizador
        /// </summary>
        /// <remarks>
        ///     
        ///     { 
        ///      "ActualPassword": "Password atual" 
        ///      "NewPassword": "Password nova"
        ///     }
        ///     
        /// </remarks>
        /// <param name="passwordUpdateModel">Nova password</param>
        /// <returns>
        /// True caso a password seja atualizada com sucesso
        /// False caso contrário
        /// </returns>
        /// <response code="200">True (Password alterada)</response>
        /// <response code="400">Bad Request</response>
        /// <response code="401">Unauthorized</response>
        [HttpPut]
        [Route("update-password")]
        [Authorize]
        public IActionResult UpdatePassword(UserUpdatePassword passwordUpdateModel)
        {
            try
            {
                int? id = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

                if (id == null)
                {
                    return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
                }

                UserDAO userDAO = new UserDAO(_connection);
                bool newPass = userDAO.UpdatePassword(passwordUpdateModel, id);
                return Ok(new SuccessExceptionModel("Password alterada com sucesso!"));
            }
            catch (Exception ex)
            {
                return BadRequest(new ErrorExceptionModel(ex.Message));
            }
        }

        /// <summary>
        /// Obtém a lista de trabalhos pendentes de um Mate
        /// </summary>
        /// <remarks>
        /// 
        ///     GET /pending
        /// 
        /// </remarks>
        /// <returns>A lista de trabalhos pendentes</returns>
        /// <response code="200">Retorna a lista de trabalhos pendentes</response>
        /// <response code="404">Not Found</response>
        [HttpGet]
        [Route("getOwnPublications")]
        [Authorize]
        public IActionResult GetPublications()
        {
            try
            {
                int? uId = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

                if (uId == null)
                {
                    return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
                }
                UserDAO userDAO = new UserDAO(_connection);
                List<Publication> reult = userDAO.GetPublications((int)uId);

                return Ok(reult);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        /// <summary>
        /// Permite atualizar uma publicação
        /// </summary>
        /// <returns>A publicação atualizada</returns>
        /// <response code="200">A publicação atualizada</response>
        /// <response code="404">Not Found</response>
        [HttpPut]
        [Route("UpdatePublication")]
        [Authorize]
        public ActionResult<Publication> UpdatePublications(Publication p)
        {
            int? uId = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

            if (uId == null)
            {
                return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
            }
            UserDAO userDAO = new UserDAO(_connection);
            Publication publication = userDAO.FindPublicationById(p.Id);
            if (publication.UtilizadorId != uId)
            {
                return NotFound("Publicação não encontrada!");
            }
            Publication updated = userDAO.UpdatePublication(p);

            return Ok(updated);
        }

        /// <summary>
        /// Metodo que permite eliminar uma publicação
        /// </summary>
        /// <returns>A publicação eliminada</returns>
        /// <response code="200">A publicação eliminada</response>
        /// <response code="404">Not Found</response>
        [HttpDelete]
        [Route("DeletePublication/{publicationId}")]
        [Authorize]
        public ActionResult<Publication> DeletePublication(int publicationId)
        {

            int? uId = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

            if (uId == null)
            {
                return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
            }
            UserDAO userDAO = new UserDAO(_connection);
            Publication publication = userDAO.FindPublicationById(publicationId);
            if (publication.UtilizadorId != uId)
            {
                return NotFound("Publicação não encontrada!");
            }
            bool deleted = userDAO.DeletePublication(publicationId);

            return Ok(deleted);
        }


        /// <summary>
        /// Rota para ver uma lista das publicacoes favoritas
        /// </summary>
        /// <param name="id">id da Publication</param>
        /// <param name="images">coleção de imagens</param>
        /// <param name="mainImage">Imagem de destaque</param>
        /// <response code="200">Caminhos das imagens</response>
        /// <response code="403">Forbidden</response>
        /// <response code="404">Not Found</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [HttpGet]
        [Route("getPublicationFromFavorites")]
        [Authorize]
        public IActionResult GetPublicationFromFavorites()
        {
            try
            {
                int? uId = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

                if (uId == null)
                {
                    return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
                }
                UserDAO userDAO = new UserDAO(_connection);
                List<Publication> reult = userDAO.GetPublicationFromFavorites((int)uId);

                return Ok(reult);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        /// <summary>
        /// Rota para eliminar publicacao dos favoritos
        /// </summary>
        /// <param name="id">id da Publication</param>
        /// <param name="images">coleção de imagens</param>
        /// <param name="mainImage">Imagem de destaque</param>
        /// <response code="200">Caminhos das imagens</response>
        /// <response code="403">Forbidden</response>
        /// <response code="404">Not Found</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [HttpDelete]
        [Route("DeletePublicationFromFavorites")]
        [Authorize]
        public IActionResult DeletePublicationfromFavorites(int pId)
        {
            try
            {
                int? uId = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

                if (uId == null)
                {
                    return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
                }
                UserDAO userDAO = new UserDAO(_connection);
                bool reult = userDAO.DeletePublicationFromFavorites((int)uId, pId);

                return Ok(reult);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        /// <summary>
        /// Rota para obter um utilizador por Id
        /// </summary>
        /// <param name="userId">Id do user</param>
        /// <returns>Retorna o User</returns>
        /// <response code="200">User</response>
        /// <response code="403">Forbidden</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [Authorize]
        [HttpGet]
        [Route("GetUserById/{userId}")]
        public IActionResult GetUserById(int userId)
        {
            try
            {

                UserDAO userDAO = new UserDAO(_connection);
                User user = userDAO.FindById(userId);

                if (user == null)
                {
                    return BadRequest("Utilizador não encontrado!");
                }

                return Ok(user);

            }
            catch (Exception ex)
            {
                return BadRequest(new ErrorExceptionModel(ex.Message));
            }

        }

        /// <summary>
        /// Rota para obter um utilizador por email
        /// </summary>
        /// <param name="email">Email do user</param>
        /// <returns>Retorna o User</returns>
        /// <response code="200">User</response>
        /// <response code="403">Forbidden</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [HttpGet]
        [Route("GetUserByEmail")]
        public IActionResult GetUserByEmail(string email)
        {
            try
            {

                UserDAO userDAO = new UserDAO(_connection);
                User user = userDAO.FindUserByEmail(email);

                if (user == null)
                {
                    return BadRequest("Utilizador não encontrado!");
                }

                return Ok(user);

            }
            catch (Exception ex)
            {
                return BadRequest(new ErrorExceptionModel(ex.Message));
            }
        }

        /// <summary>
        /// Rota para fazer Upload de uma imagem 
        /// de perfil de user
        /// </summary>
        /// <param name="profilePic">Imagem</param>
        /// <returns>
        /// Imagem de perfil definida!
        /// </returns>
        /// <response code="200">Imagem de perfil definida!</response>
        /// <response code="400">Bad Request</response>
        /// <response code="401">Unauthorized</response>
        [HttpPost]
        [Route("UploadProfilePic")]
        [Authorize]
        public IActionResult UploadProfilePic(IFormFile profilePic)
        {

            try
            {
                int? id = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

                if (id == null)
                {
                    return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
                }
                UserDAO userDAO = new UserDAO(_connection);
                bool message = userDAO.UploadImagesToUser((int)id, profilePic);

                return Ok(message);

            }
            catch (Exception ex)
            {
                return BadRequest(new ErrorExceptionModel(ex.Message));
            }

        }

        /// <summary>
        /// Rota para obter a imagem de perfil de um user
        /// </summary>
        /// <param name="user">Id do user</param>
        /// <returns>Nome da imagem de destaque</returns>
        /// <response code="200">Nome da imagem de destaque</response>
        /// <response code="403">Forbidden</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [HttpGet]
        [Route("getProfilePicture")]
        [Authorize]
        public IActionResult getProfilePicture(int user)
        {
            try
            {
                UserDAO userDAO = new UserDAO(_connection);
                ImageName image = userDAO.getProfileImage(user);
                return Ok(image);
            }
            catch (Exception e)
            {
                return BadRequest(new ErrorExceptionModel(e.Message));
            }
        }

        /// <summary>
        /// Rota para apagar a imagem de perfil do utilizador
        /// </summary>
        /// <returns>Imagem Apagada!</returns>
        /// <response code="200">Imagem Apagada!</response>
        /// <response code="403">Forbidden</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [HttpDelete]
        [Route("deleteProfilePicture")]
        [Authorize]
        public IActionResult deleteProfilePicture()
        {

            int? id = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

            if (id == null)
            {
                return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
            }
            try
            {
                UserDAO userDAO = new UserDAO(_connection);
                bool deleted = userDAO.deleteImage((int)id);

                if (deleted == true)
                {
                    return Ok(new SuccessExceptionModel("Imagem apagada!"));
                }
                else
                {
                    return BadRequest(new ErrorExceptionModel("Imagem não apagada ou inexistente!"));
                }

            }
            catch (Exception e)
            {
                return BadRequest(new ErrorExceptionModel(e.Message));
            }
        }

    }
}
