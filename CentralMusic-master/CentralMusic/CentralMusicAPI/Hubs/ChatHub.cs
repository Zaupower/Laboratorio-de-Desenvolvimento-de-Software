using CentralMusicAPI.Interfaces;
using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace CentralMusicAPI.Hubs
{ /// <summary>
  /// Classe que extende Hub, esta classe recebe mensagens atraves da classe "chat.js", as mensagens
  /// passam pelas funcoes devidas.
  /// As funcoes enviam as mensagens em grupo e sao actualizadas pela classse "chat.js"
  /// que por sua vez actualizam a informacao na pagina web
  /// </summary>
    //[Authorize]
    public class ChatHub : Hub
    {
        /// <summary>
        /// 
        /// </summary>
        public IConnection _connection;

        /// <summary>
        /// Adiciona um user a um realTime group
        /// </summary>
        /// <param name="groupName"></param>
        /// <param name="user"></param>
        /// <returns>Cahamada para a funcao EnteredOrLEft em chat.js</returns>
        //[Authorize(Roles = "M8,EMPLOYER")]
        public async Task AddToGroup(string groupName, string user)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
            await Clients.Group(groupName).SendAsync("EnteredOrLEft",
                $"{Context.ConnectionId} has" +
                $" joined the group");
        }

        /// <summary>
        /// Remove um user de um RealTime group
        /// </summary>
        /// <param name="groupName"></param>
        /// <param name="user"></param>
        /// <returns>Chamada para a funcao EnteredOrLEft em chat.js </returns>
        //[Authorize(Roles = "M8,EMPLOYER")]
        public async Task RemoveFromGroup(string groupName, string user)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, groupName);

            await Clients.Group(groupName).SendAsync("EnteredOrLEft",
                $"{Context.ConnectionId} has" +
                $" left the group");
        }

        /// <summary>
        /// Envia uma mensagem em realTime para todos os utilizadores de um grupo
        /// </summary>
        /// <param name="groupId"></param>
        /// <param name="user"></param>
        /// <param name="message"></param>
        /// <returns>Mesagem  recebida para todos os utilizadores presentes no grupo</returns>
        //[Authorize(Roles = "M8,EMPLOYER")]
        public async Task SendMessageGroup(string groupId, string user, string message)
        {
            //Send message in real time to all online group users
            await Clients.Group(groupId).SendAsync("ReceiveGroupMessage", user, message);

        }

        /// <summary>
        /// envia um sinal para um grupo a dizer que um utilizador esta a escrever
        /// </summary>
        /// <param name="groupName"></param>
        /// <param name="user"></param>
        /// <returns>Cahamada para a funcao TypingMessage em chat.js</returns>
        //[Authorize(Roles = "M8,EMPLOYER")]
        public async Task TypingGroup(string groupName, string user)
        {
            await Clients.Group(groupName).SendAsync("TypingMessage", user);
        }

        /// <summary>
        /// Funcao simples de enviar mensagem para todos os utilizadores online
        /// </summary>
        /// <param name="user"></param>
        /// <param name="message"></param>
        /// <returns>Chamada para a funcao ReceiveMessage em chat.js</returns>
        //[Authorize(Roles = "M8,EMPLOYER")]
        public async Task SendMessage(string id, string description, string tittle, string imgPath, string price, string userId, string cat, string district)
        {
            await Clients.All.SendAsync("onReceivePublication", id, description, tittle, imgPath, price, userId, cat, district);
        }

        public async Task SendPost(string user, string message)
        {
            await Clients.All.SendAsync("onReceivePublication", user, message);
        }
    }
}
