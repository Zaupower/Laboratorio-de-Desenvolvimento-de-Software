namespace CentralMusicAPI.Entities
{
    /// <summary>
    /// Classe que repesenta um Chat
    /// </summary>
    public class Chat
    {
        /// <summary>
        /// Id de utilizador
        /// </summary>
        public int UserId { get; set; }
        /// <summary>
        /// Id do chat associado
        /// </summary>
        public int ChatId { get; set; }
        public int PublicationId { get; set; }
        public string PublicationName { get; set; }
    }
}
