using CentralMusicAPI.Entities;
using CentralMusicAPI.Models.Session;
using System;

namespace CentralMusicAPI.Interfaces
{
    /// <summary>
    /// Interface para efetuar operações na base de dados
    /// relativas ao Login
    /// </summary>

    public interface ILoginDAO : IDisposable
    {
        /// <summary>
        /// Método para autenticar um User
        /// </summary>
        /// <param name="email">O email do utilizador a ser autenticado</param>
        /// <param name="password">A password do utilizador a ser autenticado</param>
        /// <returns>Retorna o User autenticado</returns>
        User Authenticate(string email, string password);

        /// <summary>
        /// Método para recuperar a password
        /// </summary>
        /// <param name="newPass">Nova Password</param>
        /// <param name="email">Email do user que vai alterar a password</param>
        /// <returns>Retorna bool</returns>
        public bool RecoverPassword(RecoverPasswordModel newPass, string email);

    }
}
