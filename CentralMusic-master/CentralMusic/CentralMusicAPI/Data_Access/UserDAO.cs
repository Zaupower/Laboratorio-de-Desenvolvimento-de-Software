using CentralMusicAPI.Entities;
using CentralMusicAPI.Entities.Enums;
using CentralMusicAPI.Helpers;
using CentralMusicAPI.Interfaces;
using CentralMusicAPI.Models;
using CentralMusicAPI.Models.Users;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CentralMusicAPI.Data_Access
{
    /// <summary>
    /// DAO para efetuar operações na base de dados
    /// relativas ao User
    /// </summary>

    public class UserDAO : IUserDAO<User>
    {
        private IConnection _connection;

        /// <summary>
        /// Método construtor da classe UserDAO
        /// </summary>
        /// <param name="connection">Objeto Connection</param>
        public UserDAO(IConnection connection)
        {
            _connection = connection;
        }

        /// <summary>
        /// Método para criar/registar um utilizador na base de dados
        /// </summary>
        /// <param name="model">Modelo do utilizador com os dados</param>
        /// <returns>Utilizador caso seja adicionado com sucesso,
        /// senão retorna NULL</returns>
        public User Create(User model)
        {
            try
            {
                using (SqlCommand cmd = _connection.Fetch().CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "INSERT INTO dbo.[User] (Email, Password, PasswordSalt, FirstName, LastName, Localization)" +
                        "VALUES (@Email, @Pass, @Salt, @Fname, @Lname, @Local); SELECT @@Identity";

                    cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = model.Email;
                    var password = PasswordEncrypt.Encrypt(model.Password);
                    cmd.Parameters.Add("@Pass", SqlDbType.NVarChar).Value = password.Item2;
                    cmd.Parameters.Add("@Salt", SqlDbType.NVarChar).Value = password.Item1;
                    cmd.Parameters.Add("@Fname", SqlDbType.NVarChar).Value = model.FirstName;
                    cmd.Parameters.Add("@Lname", SqlDbType.NVarChar).Value = model.LastName;
                    cmd.Parameters.Add("@Local", SqlDbType.NVarChar).Value = model.Localization;

                    model.Id = int.Parse(cmd.ExecuteScalar().ToString());
                }

                return model;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        /// <summary>
        /// Método para atualizar dados pessoais de um utilizador
        /// </summary>
        /// <param name="model">Modelo com os parametros do utilizador</param>
        /// <param name="id">Id do utilizador a ser atualizado</param>
        /// <returns>Utilizador atualizado</returns>
        public User Update(User model, int id)
        {
            User find = FindById((int)id);

            try
            {
                using (SqlCommand cmd = _connection.Fetch().CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "UPDATE dbo.[User] SET Email = @Email, FirstName = @Fname, LastName = @Lname, Localization = @Local " +
                        "WHERE Id = @id";

                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = id;


                    if (String.IsNullOrWhiteSpace(model.Email))
                    {
                        cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = find.Email;
                    }
                    else
                    {
                        cmd.Parameters.Add("@Email", SqlDbType.NVarChar).Value = model.Email;
                    }

                    if (String.IsNullOrWhiteSpace(model.FirstName))
                    {
                        cmd.Parameters.Add("@Fname", SqlDbType.NVarChar).Value = find.FirstName;
                    }
                    else
                    {
                        cmd.Parameters.Add("@Fname", SqlDbType.NVarChar).Value = model.FirstName;
                    }

                    if (String.IsNullOrWhiteSpace(model.LastName))
                    {
                        cmd.Parameters.Add("@Lname", SqlDbType.NVarChar).Value = find.LastName;
                    }
                    else
                    {
                        cmd.Parameters.Add("@Lname", SqlDbType.NVarChar).Value = model.LastName;
                    }

                    if (String.IsNullOrWhiteSpace(model.Localization))
                    {
                        cmd.Parameters.Add("@Local", SqlDbType.NVarChar).Value = find.Localization;
                    }
                    else
                    {
                        cmd.Parameters.Add("@Local", SqlDbType.NVarChar).Value = model.Localization;
                    }

                    cmd.ExecuteNonQuery();

                }
                return model;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

        }

        /// <summary>
        /// Método que atualiza a password
        /// de um determindado utilizador
        /// </summary>
        /// <param name="newPass">Nova palavra-passe</param>
        /// <param name="id">Id do utilizador que pretende alterar
        /// a sua palavra-passe</param>
        /// <returns>
        /// True caso a password seja atualizada com sucesso
        /// False caso contrário
        /// </returns>
        public bool UpdatePassword(UserUpdatePassword newPass, int? id)
        {
            User user = FindById((int)id);

            if (user == null)
            {
                throw new Exception("O utilizador não existe!");
            }

            if (PasswordEncrypt.VerifyHash(newPass.ActualPassword, user.Password, user.PasswordSalt))
            {

                using (SqlCommand cmd = _connection.Fetch().CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "UPDATE dbo.[User] " +
                        "SET Password = @pass, PasswordSalt = @salt " +
                        "WHERE Id = @id";

                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = id;

                    var password = PasswordEncrypt.Encrypt(newPass.NewPassword);
                    cmd.Parameters.Add("@pass", SqlDbType.NVarChar).Value = password.Item2;
                    cmd.Parameters.Add("@salt", SqlDbType.NVarChar).Value = password.Item1;

                    if (cmd.ExecuteNonQuery() == 0)
                    {
                        return false;
                    }
                }

                return true;

            }
            else
            {
                throw new Exception("A password antiga é inválida!");
            }
        }

        /// <summary>
        /// Metodo para buscar as publicações do próprio utilizador
        /// </summary>
        /// <param name="uId"></param>
        /// <param name="pId"></param>
        /// <returns>Lista de publicações</returns>
        public List<Publication> GetPublications(int uId)
        {
            List<int> pIds = new List<int>();
            List<Publication> posts = new List<Publication>();
            string adr;


            //Get publications id
            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;

                cmd.CommandText = "SELECT * FROM [dbo].[Publication] Where UserId = @uId";
                cmd.Parameters.Add("@uId", SqlDbType.Int).Value = uId;
                using (SqlDataAdapter adpt = new SqlDataAdapter(cmd))
                {
                    DataTable table = new DataTable();
                    adpt.Fill(table);

                    foreach (DataRow row in table.Rows)
                    {
                        Publication post = new Publication
                        {
                            Id = int.Parse(row["Id"].ToString()),
                            Tittle = row["Title"].ToString(),
                            Description = row["Description"].ToString(),
                            Tradable = (bool)row["Tradable"],
                            Category = (Categories)row["Category"],
                            InitialPrice = (double)row["Price"],
                            UtilizadorId = int.Parse(row["UserId"].ToString()),
                            InstrumentCondition = (Condition)row["Condition"],
                            ImagePath = int.Parse(row["Image"].ToString()),
                        };

                        adr = row["Localization"].ToString();
                        string[] adrS = adr.Split(',');
                        Address nAdr = new Address();
                        nAdr.Street = adrS[0];
                        nAdr.StreetNumber = Int32.Parse(adrS[1]);
                        nAdr.PostalCode = adrS[2];
                        nAdr.District = adrS[3];
                        nAdr.Country = adrS[4];
                        post.UserAddress = nAdr;
                        posts.Add(post);
                    }
                }
            }
            return posts;
        }

        /// <summary>
        /// Método para atualizar os detalhes de uma Publication
        /// </summary>
        /// <param name="model">Modelo da Publication com dados novos para atualizar</param>
        /// <returns>retorna a Publication atualizada</returns>
        public Publication UpdatePublication(Publication model)
        {
            Publication p = new Publication();
            string adr;
            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {

                
                    cmd.CommandText = "UPDATE dbo.[Publication] " +
                     "SET Title=@ttl, Category=@cat, Description=@desc, Tradable=@trad, Price=@Iprice, Localization=@Add, Condition=@cond " +
                     "WHERE Id=@id";
                

                cmd.Parameters.Add("@ttl", SqlDbType.NVarChar).Value = model.Tittle;
                cmd.Parameters.Add("@cat", SqlDbType.Int).Value = model.Category;
                cmd.Parameters.Add("@cond", SqlDbType.Int).Value = model.InstrumentCondition;
                cmd.Parameters.Add("@desc", SqlDbType.NVarChar).Value = model.Description;
                cmd.Parameters.Add("@trad", SqlDbType.Bit).Value = model.Tradable;
                cmd.Parameters.Add("@Iprice", SqlDbType.Float).Value = model.InitialPrice;
                cmd.Parameters.Add("@Add", SqlDbType.NVarChar).Value = model.UserAddress.ToString();
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = model.Id;
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.HasRows)
                    {

                        reader.Read();
                        p.Id = reader.GetInt32(0);
                        p.Tittle = reader.GetString(1);
                        p.Category = (Categories)reader.GetInt32(2);
                        p.InstrumentCondition = (Condition)reader.GetInt32(3);
                        p.ImagePath = reader.GetInt32(4);
                        p.Description = reader.GetString(5);
                        p.Tradable = reader.GetBoolean(6);
                        p.InitialPrice = reader.GetDouble(7);
                        adr = reader.GetString(8);
                        string[] adrS = adr.Split(',');
                        Address nAdr = new Address();
                        nAdr.Street = adrS[0];
                        nAdr.StreetNumber = Int32.Parse(adrS[1]);
                        nAdr.PostalCode = adrS[2];
                        nAdr.District = adrS[3];
                        nAdr.Country = adrS[4];
                        p.UserAddress = nAdr;
                        p.UtilizadorId = reader.GetInt32(9);

                    }
                }
            }

            return model;
        }

        /// <summary>
        /// Método para apagar uma Publication
        /// </summary>
        /// <param name="toDelete">Objeto Publication que vai ser apagada</param>
        /// <returns>True se for apagado, false caso contrário</returns>
        public bool DeletePublication(int publicationId)
        {
            bool deleted = false;

            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {

                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "DELETE FROM dbo.[Publication] WHERE Id=@id;";
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = publicationId;
                if (cmd.ExecuteNonQuery() > 0)
                {
                    deleted = true;
                }
            }

            return deleted;
        }

        public Publication FindPublicationById(int id)
        {
            Publication p = new Publication();
            string adr;
            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "SELECT Id, Title, Category, Condition, Image, Description," +
                    " Tradable, Price, Localization, UserId From dbo.Publication WHERE Id = @id;  SELECT @@Identity";

                cmd.Parameters.Add("@id", SqlDbType.Int).Value = id;
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.HasRows)
                    {

                        reader.Read();
                        p.Id = reader.GetInt32(0);
                        p.Tittle = reader.GetString(1);
                        p.Category = (Categories)reader.GetInt32(2);
                        p.InstrumentCondition = (Condition)reader.GetInt32(3);
                        p.ImagePath = reader.GetInt32(4);
                        p.Description = reader.GetString(5);
                        p.Tradable = reader.GetBoolean(6);
                        p.InitialPrice = reader.GetDouble(7);
                        adr = reader.GetString(8);
                        string[] adrS = adr.Split(',');
                        Address nAdr = new Address();
                        nAdr.Street = adrS[0];
                        nAdr.StreetNumber = Int32.Parse(adrS[1]);
                        nAdr.PostalCode = adrS[2];
                        nAdr.District = adrS[3];
                        nAdr.Country = adrS[4];
                        p.UserAddress = nAdr;
                        p.UtilizadorId = reader.GetInt32(9);

                    }
                }

            }
            return p;
        }

        /// <summary>
        /// Metodo para buscar as publicações que estão na lista de favoritos
        /// </summary>
        /// <param name="uId"></param>
        /// <param name="pId"></param>
        /// <returns>Lista de publicações</returns>
        public List<Publication> GetPublicationFromFavorites(int uId)
        {
            List<int> pIds = new List<int>();
            List<Publication> posts = new List<Publication>();
            string adr;


            //Get favorite publications id
            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;

                cmd.CommandText = "SELECT [UserId] ,[PublicationId] FROM[dbo].[FavoritePublications] Where UserId = @uId";
                cmd.Parameters.Add("@uId", SqlDbType.Int).Value = uId;
                using (SqlDataAdapter adpt = new SqlDataAdapter(cmd))
                {
                    DataTable table = new DataTable();
                    adpt.Fill(table);

                    foreach (DataRow row in table.Rows)
                    {
                        pIds.Add(int.Parse(row["PublicationId"].ToString()));
                    }
                }
            }

            foreach (int id in pIds)
            {
                //Get favorite publications id
                using (SqlCommand cmd = _connection.Fetch().CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText = "SELECT Id,Title,Category,Condition,Image" +
                        ",Description,Tradable,Price,Localization,UserId " +
                        "FROM[dbo].[Publication] Where Id = @uId;";
                    cmd.Parameters.Add("@uId", SqlDbType.Int).Value = id;
                    using (SqlDataAdapter adpt = new SqlDataAdapter(cmd))
                    {
                        DataTable table = new DataTable();
                        adpt.Fill(table);

                        foreach (DataRow row in table.Rows)
                        {
                            Publication post = new Publication
                            {
                                Id = int.Parse(row["Id"].ToString()),
                                Tittle = row["Title"].ToString(),
                                Description = row["Description"].ToString(),
                                Tradable = (bool)row["Tradable"],
                                Category = (Categories)row["Category"],
                                InitialPrice = (double)row["Price"],
                                UtilizadorId = int.Parse(row["UserId"].ToString()),
                                InstrumentCondition = (Condition)row["Condition"],
                                ImagePath = int.Parse(row["Image"].ToString()),
                            };

                            adr = row["Localization"].ToString();
                            string[] adrS = adr.Split(',');
                            Address nAdr = new Address();
                            nAdr.Street = adrS[0];
                            nAdr.StreetNumber = Int32.Parse(adrS[1]);
                            nAdr.PostalCode = adrS[2];
                            nAdr.District = adrS[3];
                            nAdr.Country = adrS[4];
                            post.UserAddress = nAdr;
                            posts.Add(post);
                        }
                    }
                }
            }
            return posts;
        }

        /// <summary>
        ///  Delete Publication from favorites
        /// </summary>
        /// <param name="uId"></param>
        /// <param name="pId"></param>
        /// <returns></returns>
        public bool DeletePublicationFromFavorites(int uId, int pId)
        {
            bool result = false;
            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;

                cmd.CommandText = "Delete From dbo.FavoritePublications Where UserId = @uId and PublicationId = @pId";
                cmd.Parameters.Add("@uId", SqlDbType.Int).Value = uId;
                cmd.Parameters.Add("@pId", SqlDbType.Int).Value = pId;
                cmd.ExecuteScalar();
                result = true;
            }
            return result;
        }


        /// <summary>
        /// Método que procura um utilizador
        /// através do seu email
        /// </summary>
        /// <param name="email">Email do utilizador a pesquisar</param>
        /// <returns>O utilizador encontrado</returns>
        public User FindUserByEmail(string email)
        {
            User user = null;

            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "SELECT Id, Email, Password, PasswordSalt, FirstName, LastName, Localization " +
                    "FROM dbo.[User] " +
                    "WHERE Email = @email";

                cmd.Parameters.Add("@email", SqlDbType.NVarChar).Value = email;

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.HasRows)
                    {
                        user = new User();
                        reader.Read();
                        user.Id = reader.GetInt32(0);
                        user.Email = reader.GetString(1);
                        user.Password = reader.GetString(2);
                        user.PasswordSalt = reader.GetString(3);
                        user.FirstName = reader.GetString(4);
                        user.LastName = reader.GetString(5);
                        user.Localization = reader.GetString(6);
                    }
                }
            }
            return user;
        }

        /// <summary>
        /// Método para encontrar o utilizador por ID
        /// </summary>
        /// <param name="userId">Id do utilizador</param>
        /// <returns>Retorna o utilizador pretendido, senao retorna null</returns>
        public User FindById(int userId)
        {

            User user = null;

            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "SELECT Id, Email, Password, PasswordSalt, FirstName, LastName, Localization " +
                    "FROM dbo.[User] " +
                    "WHERE Id = @Id";

                cmd.Parameters.Add("@Id", SqlDbType.NVarChar).Value = userId;

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.HasRows)
                    {
                        user = new User();
                        reader.Read();
                        user.Id = reader.GetInt32(0);
                        user.Email = reader.GetString(1);
                        user.Password = reader.GetString(2);
                        user.PasswordSalt = reader.GetString(3);
                        user.FirstName = reader.GetString(4);
                        user.LastName = reader.GetString(5);
                        user.Localization = reader.GetString(6);
                    }
                }
            }
            return user;
        }

        /// <summary>
        /// Método para fazer Upload de imagens para o perfil de
        /// utilizador
        /// </summary>
        /// <param name="id">id do user</param>
        /// <param name="mainImage">Imagem</param>
        /// <returns>Caminho da imagem</returns>
        public bool UploadImagesToUser(int id, IFormFile mainImage)
        {
            bool result = true;
            try
            {
                ImageUploadHelper imageUploadHelper = new ImageUploadHelper();
                string imagesPath = imageUploadHelper.UploadImage(mainImage, id, "user");

                return result;

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        /// <summary>
        /// Método que retorna o nome da imagem de perfil
        /// do user
        /// </summary>
        /// <param name="id">Id do user</param>
        /// <returns>Nome da Imagem de perfil</returns>
        public ImageName getProfileImage(int id)
        {

            if (FindById(id) == null)
            {
                throw new Exception("O user não existe!");
            }

            try
            {
                ImageUploadHelper imageUploadHelper = new ImageUploadHelper();
                return imageUploadHelper.getMainImage(id, "user");
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        /// <summary>
        /// Método que apaga a imagem de perfil do utilizador
        /// </summary>
        /// <param name="id">Id do utilizador</param>
        /// <returns>Retorna True se a imagem é apagada, False caso contrário</returns>
        public bool deleteImage(int id)
        {
            try
            {
                ImageUploadHelper imageUploadHelper = new ImageUploadHelper();
                return imageUploadHelper.deleteUserImage(id, "user");
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
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
