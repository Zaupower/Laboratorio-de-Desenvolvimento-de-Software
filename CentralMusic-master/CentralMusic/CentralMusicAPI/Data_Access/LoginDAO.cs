using CentralMusicAPI.Entities;
using CentralMusicAPI.Helpers;
using CentralMusicAPI.Interfaces;
using CentralMusicAPI.Models.Session;
using System;
using System.Data;
using System.Data.SqlClient;

namespace CentralMusicAPI.Data_Access
{
    /// <summary>
    /// DAO para efetuar operações na base de dados
    /// relativas ao Login de um utilizador
    /// </summary>
    public class LoginDAO : ILoginDAO
    {
        private readonly IConnection _connection;

        /// <summary>
        /// Método construtor do LoginDAO
        /// </summary>
        /// <param name="connection">Objeto com a conexão à BD</param>
        public LoginDAO(IConnection connection)
        {
            _connection = connection;
        }


        public User Authenticate(string email, string password)
        {
            // Caso o email ou a password sejam nulas ou campos vazios
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                return null;
            }

            UserDAO userDAO = new UserDAO(_connection);
            User user = userDAO.FindUserByEmail(email);

            // Caso o utilizador seja nulo ou não exista
            if (user == null)
            {
                return null;
            }

            // Necessário verificar a hash da password do utilizador para que o mesmo se autentique. Caso não seja igual não faz login
            if (!PasswordEncrypt.VerifyHash(password, user.Password, user.PasswordSalt))
            {
                return null;
            }

            return user;
        }

        /// <summary>
        /// Método para recuperar a password
        /// </summary>
        /// <param name="newPass">Nova Password</param>
        /// <param name="email">Email do user que vai alterar a password</param>
        /// <returns>Retorna bool</returns>
        public bool RecoverPassword(RecoverPasswordModel newPass, string email)
        {
            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "UPDATE dbo.[User] SET Password = @pass, PasswordSalt = @salt " +
                    "WHERE Email = @email";

                cmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = email;
                var password = PasswordEncrypt.Encrypt(newPass.Password);
                cmd.Parameters.Add("@pass", SqlDbType.NVarChar).Value = password.Item2;
                cmd.Parameters.Add("@salt", SqlDbType.NVarChar).Value = password.Item1;

                newPass.Password = password.Item2;

                cmd.ExecuteNonQuery();
            }
            return true;
        }

        /// <summary>
        /// Gestão de recursos não gerenciados.
        /// Método que controla o garbage collector
        /// </summary>
        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
    }
}
