using CentralMusicAPI.Models.Users;
using System;

namespace CentralMusicAPI.Interfaces
{
    public interface IUserDAO<User> : IDisposable where User : class, new()
    {

        /// <summary>
        /// Método para criar um utilizador
        /// </summary>
        /// <param name="model">Utilizador a registar</param>
        /// <returns>O utilizadro criado</returns>
        User Create(User model);

        /// <summary>
        /// Método para atualizar dados pessoais de um utilizador
        /// </summary>
        /// <param name="model">Modelo com os parametros do utilizador</param>
        /// <param name="id">Id do utilizador a ser atualizado</param>
        /// <returns>Utilizador com os dados atualizados</returns>
        User Update(User model, int id);

        /// <summary>
        /// Método que atualiza a password
        /// de um determindado utilizador
        /// </summary>
        /// <param name="newPass"></param>
        /// <param name="id"></param>
        /// <returns>
        /// True caso a password seja atualizada com sucesso
        /// False caso contrário
        /// </returns>
        bool UpdatePassword(UserUpdatePassword newPass, int? id);

        /// <summary>
        ///  Método que procura um utilizador
        /// através do seu email
        /// </summary>
        /// <param name="email"></param>
        /// <returns>O utilizador encontrado</returns>
        User FindUserByEmail(string email);

        /// <summary>
        /// Método que procura um utilizador
        /// através do seu id
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        User FindById(int userId);

    }
}
