using System;

namespace CentralMusicAPI.Models.Chat
{
    public class Message
    {
        public int Id { get; set; }
        public int ChatId { get; set; }
        public string MessageSend { get; set; }
        public int SenderId { get; set; }
        public DateTime Time { get; set; }
    }
}
