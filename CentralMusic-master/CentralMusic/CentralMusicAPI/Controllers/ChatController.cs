using CentralMusicAPI.Configs;
using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Helpers;
using CentralMusicAPI.Hubs;
using CentralMusicAPI.Interfaces;
using CentralMusicAPI.Models.Chat;
using CentralMusicAPI.Models.Exceptions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Options;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Security.Claims;
using System.Threading.Tasks;

namespace CentralMusicAPI.Controllers
{
    /// <summary>
    /// Classe Chat Controller, aqui estao todas as funcoes necessarias para realizar o CRUD de mensagens,
    /// e retornar as imagens em tempo real atraves da instancia de chatHub
    /// </summary>
    [ApiController]
    [Route("[controller]")]
    public class ChatController : Controller
    {
        private readonly IConnection _connection;
        /// <summary>
        /// Instancia que permite utilizar funcionalidades de chatHub
        /// </summary>
        protected readonly IHubContext<ChatHub> _chatHub;

        /// <summary>
        /// Construtor de classe
        /// </summary>
        /// <param name="config"></param>
        /// <param name="chatHub"></param>
        public ChatController(IOptions<AppSettings> config, [NotNull] IHubContext<ChatHub> chatHub)
        {
            _connection = new Connection(config);
            _chatHub = chatHub;
        }

        /// <summary>
        /// Retorna todas as mensagens associadas a uma ChatId
        /// </summary>
        /// <param name="id"></param>
        /// <returns>Lista de Messagens</returns>
        [HttpGet]
        [Route("getMessagesFromChat")]
        public List<Message> GetMessages(int id)
        {
            ChatDAO chatDAO = new ChatDAO(_connection);
            List<Message> messageList = chatDAO.GetMessageList(id);

            return messageList;
        }

        /// <summary>
        /// Retorna todos os Id de chats associados a um UserId dado
        /// </summary>
        /// <param name="id"></param>
        /// <returns>Array de Chats onde o utilizador esta presente</returns>
        [HttpGet]
        [Route("getChatsFromUser")]
        [Authorize]
        public ActionResult<Chat[]> GetChatsArray()
        {
            int? id = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

            if (id == null)
            {
                return Unauthorized(new ErrorExceptionModel("Utilizador não tem autorização!"));
            }

            ChatDAO chatDAO = new ChatDAO(_connection);
            Chat[] chatArray = chatDAO.GetChats((int)id);

            return chatArray;
        }
        /// <summary>
        /// Cria um dua linhas na DB, uma com o id do M8 e do chat e outra com o id do Employer e o mesmo id de chat
        /// </summary>
        /// <param name="matchId"></param>
        /// <returns>True caso seja criado o chat com sucesso, False caso contrario</returns>
        [HttpPost]
        [Route("/createChat/")]
        [Authorize]
        public ActionResult<bool> CreateChat(int matchId, int publicationId, string publicationName )
        {
            int? userId = ClaimHelper.GetIdFromClaimIdentity((ClaimsIdentity)this.ControllerContext.HttpContext.User.Identity);

            if (userId == null)
            {
                return Unauthorized(new ErrorExceptionModel("Utilizador não tem autorização!"));
            }

            UserDAO userDAO = new UserDAO(_connection);
            User user = userDAO.FindById(matchId);
            if ( userId <0)
            {
                return UnprocessableEntity(new ErrorExceptionModel("Utilizador não existe!"));
            }

            Chat chat = new Chat();
            chat.UserId = (int)userId;
            chat.PublicationId = publicationId;
            chat.PublicationName = publicationName;
            ChatDAO chatDAO = new ChatDAO(_connection);
            chat.ChatId = chatDAO.CreateChatId();
            chatDAO.CreateChat(chat);

            chat.UserId = matchId;
            chatDAO.CreateChat(chat);

            return Ok("Concluído!");
        }

        /// <summary>
        /// Envia uma mensagem em tempo real atraves de uma instancia de Hub
        /// De seguida guarda a mensagem na DB
        /// </summary>
        /// <remarks>
        /// Sample request:
        ///     {
        ///         "id": 1,
        ///         "chatId": 1,
        ///         "messageSend": "Hello World!",
        ///         "senderId": 1,
        ///         "time": "2020-12-17T16:15:14.318Z"
        ///     }
        /// </remarks>
        /// <param name="message"></param>
        /// <returns> bool true caso a mensagem tenha sido guardada na db </returns>
        [HttpPost]
        [Route("/sendMessage")]
        //[Authorize(Roles = "M8,EMPLOYER")]
        public async Task<IActionResult> SendMessage(Message message)
        {
            //Enviar a msg em tempo real
            await _chatHub.Clients.Group(message.ChatId.ToString()).SendAsync("ReceiveGroupMessage", message.SenderId.ToString(), message.MessageSend);
            //Adicionar a mensagem a DB
            ChatDAO chatDAO = new ChatDAO(_connection);
            bool addedToDb = chatDAO.AddMessage(message);
            return Ok("Resultado: " + addedToDb);
        }

    }
}
