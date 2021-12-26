using CentralMusicAPI.Data_Access;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Models.Chat;
using System;
using System.Collections.Generic;
using System.Linq;
using Xunit;

namespace CentralMusicTestsAPI.ChatTests
{
    public class CanGetMessages
    {

        private Connection _connection;
        private ChatFixture _fixture;

        public CanGetMessages()
        {
            _fixture = new ChatFixture();
            this._connection = _fixture.GetConnection();
        }

        [Fact]
        public void CanGetChatsFromDb()
        {

            UserDAO userDAO = new UserDAO(_connection);
            User testUser1 = new User();

            testUser1.Email = "ema1@gmail.com";
            testUser1.Password = "123";
            testUser1.FirstName = "Ema";
            testUser1.LastName = "Coelho";
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

            User testUser2 = new User();
            testUser2.Email = "ema2@gmail.com";
            testUser2.Password = "123";
            testUser2.FirstName = "Ema";
            testUser2.LastName = "Coelho";
            testUser2.Password = "123";
            testUser2.Image = "ImageLocation";
            Address adr2 = new Address();
            adr2.PostalCode = "4615-423";
            adr2.Street = "Rua de Real";
            adr2.StreetNumber = 55;
            adr2.District = "Porto";
            adr2.Country = "Portugal";
            testUser2.Localization = adr2.ToString();

            //User 2 a utilizar
            User returnedUser2 = userDAO.Create(testUser2);

            Chat chat = new Chat();
            ChatDAO chatDAO = new ChatDAO(_connection);
            int chatId = chatDAO.CreateChatId();
            chat.ChatId = chatId;
            chat.UserId = returnedUser.Id;
            chatDAO.CreateChat(chat);
            chat.UserId = returnedUser2.Id;
            chatDAO.CreateChat(chat);

            Chat[] chatArrayEmploye = chatDAO.GetChats(returnedUser.Id);
            Chat[] chatArrayMate = chatDAO.GetChats(returnedUser2.Id);

            Message message = new Message();
            message.ChatId = chatId;
            message.MessageSend = "message test";
            message.SenderId = returnedUser.Id;
            message.Time = DateTime.Now;

            bool addedToDb = chatDAO.AddMessage(message);

            List<Message> returnMessages = chatDAO.GetMessageList(chatId);
            Message returnedMessage = returnMessages.First();

            Assert.Equal(message.ChatId, returnedMessage.ChatId);
            Assert.Equal(message.MessageSend, returnedMessage.MessageSend);
            Assert.Equal(message.SenderId, returnedMessage.SenderId);

            _fixture.Dispose();
        }
    }
}
