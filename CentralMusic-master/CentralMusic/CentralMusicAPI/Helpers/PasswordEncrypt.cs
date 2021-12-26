using System;
using System.Web.Helpers;

namespace CentralMusicAPI.Helpers
{
    public static class PasswordEncrypt
    {
        /// <summary>
        /// Método para encriptar a password
        /// </summary>
        /// <param name="pass">Password</param>
        /// <returns>Salt e Hash</returns>
        public static Tuple<string, string> Encrypt(string pass)
        {
            string salt = Crypto.GenerateSalt();
            string password = pass + salt;
            string hash = Crypto.HashPassword(password);

            return new Tuple<string, string>(salt, hash);
        }

        /// <summary>
        /// Método para comparar as passwords
        /// </summary>
        /// <param name="pass">Password</param>
        /// <param name="hash">Hash da Password</param>
        /// <param name="salt">Salt da Password</param>
        /// <returns>Bool com o resultado se as passwords são iguais</returns>
        public static bool VerifyHash(string pass, string hash, string salt)
        {
            pass = pass + salt;
            var hashVerify = Crypto.VerifyHashedPassword(hash, pass);

            return hashVerify;
        }

    }
}
