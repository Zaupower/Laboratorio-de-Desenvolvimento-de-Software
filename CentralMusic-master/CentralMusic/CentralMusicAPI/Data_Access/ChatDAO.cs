using CentralMusicAPI.Entities;
using CentralMusicAPI.Interfaces;
using CentralMusicAPI.Models.Chat;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace CentralMusicAPI.Data_Access
{
    /// <summary>
    /// Classe que comunica com DB para realizar operacoes CRUD com a DB
    /// </summary>
    public class ChatDAO
    {
        private IConnection _connection;

        /// <summary>
        /// Construtor de classe
        /// </summary>
        /// <param name="connection"></param>
        public ChatDAO(IConnection connection)
        {
            _connection = connection;
        }

        /// <summary>
        /// Add a message to a specific Chat with chatId
        /// </summary>
        /// <param name="message"></param>
        /// <returns> true caso seja adicionada a mensagem a DB falso caso contrario</returns>
        public bool AddMessage(Message message)
        {
            bool returnValue = false;
            if (message.MessageSend != null)
                using (SqlCommand cmd = _connection.Fetch().CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    {
                        cmd.CommandText = "INSERT INTO dbo.Message(ChatId, Message, SenderId, Time) " +
                            "VALUES(@chatId, @msg, @senderId, @time); SELECT @@Identity";

                        cmd.Parameters.Add("@chatId", SqlDbType.Int).Value = message.ChatId;
                        cmd.Parameters.Add("@msg", SqlDbType.NVarChar).Value = message.MessageSend;
                        cmd.Parameters.Add("@senderId", SqlDbType.Int).Value = message.SenderId;
                        cmd.Parameters.Add("@time", SqlDbType.DateTime).Value = DateTime.Now; 
                        cmd.ExecuteScalar();
                        returnValue = true;
                    }
                }
            return returnValue;
        }

        /// <summary>
        /// Criar um novo chat com user id
        /// </summary>
        /// <param name="model"></param>
        /// <returns> Objecto Chat criado</returns>
        public Chat CreateChat(Chat model)
        {
            if (model.ChatId != 0 && model.UserId != 0)
                using (SqlCommand cmd = _connection.Fetch().CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    {
                        cmd.CommandText = "INSERT INTO dbo.UserChat(UserId, ChatId, PublicationId, PublicationName ) " +
                            "VALUES(@userId, @chatId, @publicationId, @publicationName); ";

                        cmd.Parameters.Add("@userId", SqlDbType.Int).Value = model.UserId;
                        cmd.Parameters.Add("@chatId", SqlDbType.Int).Value = model.ChatId;
                        cmd.Parameters.Add("@publicationId", SqlDbType.Int).Value = model.PublicationId;
                        cmd.Parameters.Add("@publicationName", SqlDbType.NVarChar).Value = model.PublicationName;
                        cmd.ExecuteScalar();
                    }
                }
            return model;
        }

        /// <summary>
        /// Cria novo Chat Id 
        /// Afuncionar
        /// </summary>
        /// <returns>Chat Id criado</returns>
        public int CreateChatId()
        {
            int countDis;
            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;
                {
                    cmd.CommandText = "INSERT INTO dbo.[Chat] DEFAULT VALUES; SELECT @@Identity";

                    cmd.Parameters.Add("@val", SqlDbType.Int).Value = DBNull.Value;
                    countDis = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
            return countDis;
        }


        /// <summary>
        /// Metodo para obter todas as mensagens com userId dado
        /// </summary>
        /// <param name="chatId"></param>
        /// <returns> Lista de Mensagens </returns>
        public List<Message> GetMessageList(int chatId)
        {
            List<Message> returnMessages = new List<Message>();

            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;
                if (chatId != 0)
                {
                    cmd.CommandText = "Select dbo.[Message].* From dbo.[Message] " +
                        "Where dbo.[Message].ChatId = @id";
                }
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = chatId;

                using (SqlDataAdapter adpt = new SqlDataAdapter(cmd))
                {
                    DataTable table = new DataTable();
                    adpt.Fill(table);

                    foreach (DataRow row in table.Rows)
                    {
                        Message message = new Message
                        {
                            Id = int.Parse(row["Id"].ToString()),
                            ChatId = int.Parse(row["ChatId"].ToString()),
                            MessageSend = row["Message"].ToString(),
                            SenderId = int.Parse(row["SenderId"].ToString()),
                            Time = (DateTime)row["Time"]

                        };

                        returnMessages.Add(message);
                    }
                }
                return returnMessages;
            }
        }

        /// <summary>
        /// Metodo para obter todos chatsId dado um userId
        /// </summary>
        /// <param name="userId"></param>
        /// <returns>Um array de Chats( Chat[] )</returns>
        public Chat[] GetChats(int userId)
        {
            Chat[] returnChats = new Chat[20];

            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;
                if (userId != 0)
                {
                    cmd.CommandText = "Select dbo.[UserChat].* From dbo.[UserChat] " +
                        "Where dbo.[UserChat].UserId = @id";
                }

                cmd.Parameters.Add("@id", SqlDbType.Int).Value = userId;

                using (SqlDataAdapter adpt = new SqlDataAdapter(cmd))
                {
                    DataTable table = new DataTable();
                    adpt.Fill(table);

                    List<Chat> chats = new List<Chat>();
                    foreach (DataRow row in table.Rows)
                    {
                        Chat chat = new Chat
                        {
                            ChatId = (int)row["ChatId"],
                            UserId = (int)row["UserId"],
                            PublicationId = (int)row["PublicationId"],
                            PublicationName = row["PublicationName"].ToString()
                        };
                        chats.Add(chat);
                    }
                    //Resize array to match list size
                    int max = chats.Count();
                    returnChats = new Chat[max];
                    returnChats = chats.ToArray();
                }
            }
            return returnChats;
        }
    }
}
