namespace CentralMusicAPI.Configs
{
    /// <summary>
    /// classe com informação relativa á BD e autenticação
    /// </summary>
    public class AppSettings
    {
        /// <summary>
        /// String de conexão á base de dados
        /// </summary>
        public string DBConnection { get; set; }
        /// <summary>
        /// secret para autenticação jwt
        /// </summary>
        public string Secret { get; set; }
    }
}
