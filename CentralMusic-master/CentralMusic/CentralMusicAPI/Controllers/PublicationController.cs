using CentralMusicAPI.Configs;
using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities.Enums;
using CentralMusicAPI.Helpers;
using CentralMusicAPI.Hubs;
using CentralMusicAPI.Interfaces;
using CentralMusicAPI.Models;
using CentralMusicAPI.Models.Exceptions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Security.Claims;
using System.Threading.Tasks;

namespace CentralMusicAPI.Controllers
{
    /// <summary>
    /// Classe controlador de Publication
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class PublicationController : Controller
    {
        private readonly IConnection _connection;
        private IWebHostEnvironment _environment;

        /// <summary>
        /// Instancia que permite utilizar funcionalidades de chatHub
        /// </summary>
        protected readonly IHubContext<ChatHub> _chatHub;

        public PublicationController(IOptions<AppSettings> config, IWebHostEnvironment environment, [NotNull] IHubContext<ChatHub> chatHub)
        {
            _environment = environment;
            _connection = new Connection(config);
            _chatHub = chatHub;
            _connection.Fetch();
        }

        /// <summary>
        /// Criar uma publicação
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("CreatePublication")]
        [Authorize]
        public async Task<IActionResult> Create(PuplicationCreate model)
        {
           int? uId = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

            if (uId == null)
            {
              return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
            }
            if(model.ImagePath == null)
            {
                model.ImagePath = 0;
            }
            model.UtilizadorId = (int)uId;
           
            PublicationDAO publicationDao = new PublicationDAO(_connection);
            Publication resultPublication = publicationDao.Create(model);
            resultPublication.UtilizadorId = (int)uId;
            resultPublication.Tittle = model.Tittle;
            resultPublication.Tradable = model.Tradable;
            resultPublication.UserAddress = model.UserAddress;
            resultPublication.InstrumentCondition = model.InstrumentCondition;
            resultPublication.InitialPrice = model.InitialPrice;
            resultPublication.Category = model.Category;
            return Ok(resultPublication);

        }

        //
        /// <summary>
        /// Pesquisa por palavra chave (key), ou categoria ou por raio distancia com morada
        /// </summary>
        /// <param name="key"></param>
        /// <param name="categories"></param>
        /// <param name="address"></param>
        /// <param name="distancel"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("GetPublication")]
        public ActionResult<Publication> GetPublications([FromQuery(Name = "key")] string key, [FromQuery(Name = "categories")] Categories[] categories, [FromQuery(Name = "address")] string address, [FromQuery(Name = "distance")] int? distancel)
        {
            PublicationDAO publicationDao = new PublicationDAO(_connection);
            List<Publication> resultPublication = publicationDao.GetPublications(key, categories, address, distancel);

            return Ok(resultPublication);
        }

        /// <summary>
        /// Rota para fazer upload de imagens para uma Publication
        /// </summary>
        /// <param name="id">id da Publication</param>
        /// <param name="images">coleção de imagens</param>
        /// <param name="mainImage">Imagem de destaque</param>
        /// <response code="200">Caminhos das imagens</response>
        /// <response code="403">Forbidden</response>
        /// <response code="404">Not Found</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [HttpPost]
        [Route("UpdateImagePublication")]
        [Authorize]
        public IActionResult UploadImagesToPost(int id, [FromForm] IFormFileCollection images, IFormFile mainImage)
        {
            try
            {
                int? uId = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

                if (uId == null)
                {
                    return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
                }
                PublicationDAO pDAO = new PublicationDAO(_connection);
                Publication p = pDAO.FindById(id);
                if (p.UtilizadorId != uId)
                {
                    return NotFound("Publicação não encontrada!");
                }

                bool result = pDAO.UploadImagesToPost(id, images, mainImage);

                return Ok(result);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        /// <summary>
        /// Rota para fazer adicionar publicacao  aos favoritos
        /// </summary>
        /// <param name="id">id da Publication</param>
        /// <param name="images">coleção de imagens</param>
        /// <param name="mainImage">Imagem de destaque</param>
        /// <response code="200">Caminhos das imagens</response>
        /// <response code="403">Forbidden</response>
        /// <response code="404">Not Found</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [HttpPost]
        [Route("AddPublicationToFavorites")]
        [Authorize]
        public IActionResult AddPublicationToFavorites(int pId)
        {
            try
            {
                int? uId = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

                if (uId == null)
                {
                    return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
                }
                PublicationDAO pDAO = new PublicationDAO(_connection);
                bool reult = pDAO.AddPublicationToFavorites((int)uId, pId);

                return Ok(reult);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        /// <summary>
        /// Rota para obter uma lista com os 
        /// nomes das imagens de uma Publication
        /// </summary>
        /// <param name="post">Id da Publication</param>
        /// <returns>Lista com nomes de imagens</returns>
        /// <response code="200">Lista com nomes de imagens</response>
        /// <response code="403">Forbidden</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [HttpGet]
        [Route("GetImagePublication")]
        [AllowAnonymous]
        public IActionResult getPicturesNames(int id)
        {
            try
            {
                PublicationDAO pDAO = new PublicationDAO(_connection);
                List<ImageName> images = pDAO.getImages(id);
                return Ok(images);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        /// <summary>
        /// Rota para obter o nome da imagem de
        /// destaque de uma publicacao
        /// </summary>
        /// <param name="post">Id da Publication</param>
        /// <returns>Nome da imagem de destaque</returns>
        /// <response code="200">Nome da imagem de destaque</response>
        /// <response code="403">Forbidden</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [HttpGet]
        [Route("GeteMainImagePublication")]
        [AllowAnonymous]
        public IActionResult getMainPicture(int id)
        {
            try
            {
                PublicationDAO pDAO = new PublicationDAO(_connection);
                ImageName image = pDAO.getMainImage(id);
                return Ok(image);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        /// <summary>
        /// Rota para apagar a imagem de destaque de uma Publication
        /// </summary>
        /// <param name="post">Id da publication</param>
        /// <param name="image">Objeto imageName com o nome da imagem</param>
        /// <returns>Imagem apagada!</returns>
        /// <response code="200">Imagem apagada!</response>
        /// <response code="403">Forbidden</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [HttpDelete]
        [Route("DeleteMainImagePublication")]
        [Authorize]
        public IActionResult deleteMainPicture(int publicationId, ImageName image)
        {
            try
            {
                int? id = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

                if (id == null)
                {
                    return Unauthorized(new ErrorExceptionModel("Sem Autorização ou sem sessão inciada"));
                }
                PublicationDAO pDAO = new PublicationDAO(_connection);
                bool deleted = pDAO.deleteMainImage(publicationId, image);

                if (deleted == true)
                {
                    return Ok("Imagem apagada!");
                }
                else
                {
                    return BadRequest("Imagem não apagada ou inexistente!");
                }

            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        /// <summary>
        /// Rota para apagar a imagem de uma Publication
        /// </summary>
        /// <param name="post">Id </param>
        /// <param name="image">Objeto imageName com o nome da imagem</param>
        /// <returns>Imagem apagada!</returns>
        /// <response code="200">Imagem apagada!</response>
        /// <response code="403">Forbidden</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="400">Bad Request</response>
        [HttpDelete("deleteImage/{post}")]
        [Authorize]
        public IActionResult deleteImage(int post, ImageName image)
        {

            //Implementar claim identity do user e levar o id em delete Image
            if (image == null)
            {
                return BadRequest("Nome de imagem não enviado!");
            }

            try
            {
                PublicationDAO pDAO = new PublicationDAO(_connection);
                bool deleted = pDAO.deleteImage(post, image);

                if (deleted == true)
                {
                    return Ok("Imagem apagada!");
                }
                else
                {
                    return BadRequest("Imagem não apagada ou inexistente!");
                }

            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
    }
}
