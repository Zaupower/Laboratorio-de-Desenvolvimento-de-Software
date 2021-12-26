using CentralMusicAPI.Entities;
using CentralMusicAPI.Entities.Enums;
using CentralMusicAPI.Helpers;
using CentralMusicAPI.Interfaces;
using CentralMusicAPI.Models;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CentralMusicAPI.Data_Access
{

    /// <summary>
    /// DAO para efetuar operações na base de dados
    /// relativas a Publication
    /// </summary>
    public class PublicationDAO
    {
        private readonly IConnection _connection;
        private ImageUploadHelper imageUploadHelper;

        //Umas belas palavras
        public PublicationDAO(IConnection connection)
        {
            this.imageUploadHelper = new ImageUploadHelper();
            _connection = connection;
        }

        /// <summary>
        /// Método para criar uma Publication na DB 
        /// </summary>
        /// <param name="employer">Id do cleinte que vai criar uma Publication</param>
        /// <param name="model">Objeto da Publication com a informação a ser publicada</param>
        /// <returns>Retorna a Publication criada</returns>
        public Publication Create(PuplicationCreate model)
        {
            Publication p = new Publication();
            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;

               
                    cmd.CommandText = "INSERT INTO dbo.Publication(Title, Description, Tradable, Category, Price, Localization, Condition, UserId, Image)" +
                   " VALUES(@Title, @Description, @Tradable, @Category, @Price, @Localization, @Condition, @UserId, @Image);  SELECT @@Identity";
                
                string adrs = model.UserAddress.ToString();
                cmd.Parameters.Add("@Title", SqlDbType.NVarChar).Value = model.Tittle;
                cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = model.Description;
                cmd.Parameters.Add("@Tradable", SqlDbType.Bit).Value = model.Tradable;
                cmd.Parameters.Add("@Category", SqlDbType.Int).Value = model.Category;
                cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = model.UtilizadorId;
                cmd.Parameters.Add("@Condition", SqlDbType.Int).Value = model.InstrumentCondition;
                cmd.Parameters.Add("@Price", SqlDbType.Float).Value = model.InitialPrice;
                cmd.Parameters.Add("@Localization", SqlDbType.NVarChar).Value = adrs;
                cmd.Parameters.Add("@Image", SqlDbType.Int).Value = model.ImagePath;


                p.Id = int.Parse(cmd.ExecuteScalar().ToString());
            }
            return p;
        }

        public Publication FindById(int id)
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
        /// Método de pesquisa de Anuncio disponível para o cliente com vários filtros 
        /// </summary>
        /// <param name="categories">Filtro de Categorias</param>
        /// <param name="address">Filtro da Morada</param>
        /// <param name="distance">Filtro de distância</param>
        /// <param name="rating">Filtro de Rating</param>
        /// <param name="mateId"></param>
        /// <returns>Retorna a listagem de posts</returns>
        public List<Publication> GetPublications(string key, Categories[] categories, string address, int? distance)
        {
            List<Publication> posts = new List<Publication>();

            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;
                bool hasQuery = false;
                string query = " where ";

                if (categories.Length != 0)
                {
                    if (hasQuery)
                    {
                        query += "and (";
                        int lastOne = categories.Length - 1;

                        for (int i = 0; i < lastOne; i++)
                        {
                            query += "Category=" + (int)categories[i] + " or ";
                        }
                        query += "Category=" + (int)categories[lastOne] + " )";
                    }
                    else
                    {
                        hasQuery = true;
                        int lastOne = categories.Length - 1;
                        query += "(";
                        for (int i = 0; i < lastOne; i++)
                        {
                            query += "Category=" + (int)categories[i] + " or ";
                        }
                        query += "Category=" + (int)categories[lastOne] + ") ";

                    }



                }
                if (key != null)
                {
                    if (hasQuery)
                    {
                        query += "AND Description LIKE '%" + key + "%' or Title LIKE '%" + key + "%' ";
                    }
                    else
                    {
                        query += " Description LIKE '%" + key + "%' or Title LIKE '%" + key + "%' ";
                    }

                }
                if (hasQuery || key != null)
                {
                    cmd.CommandText = "SELECT * FROM Publication " + query + ";";
                }
                else
                {
                    cmd.CommandText = "SELECT * FROM Publication;";
                }
                using (SqlDataAdapter adpt = new SqlDataAdapter(cmd))
                {
                    DataTable table = new DataTable();
                    adpt.Fill(table);
                    string adr;
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

                if (address != null)
                {
                    if (distance != null)
                    {
                        Publication[] publicationPosts = posts.ToArray();
                        posts = new List<Publication>();
                        for (int i = 0; i < publicationPosts.Length; i++)
                        {
                            int? distanceToUser = DistancesHelper.calculateDistanceBetweenAddresses(address, publicationPosts[i].UserAddress.ToString());

                            if (distanceToUser != null)
                            {
                                if (distanceToUser <= distance)
                                {
                                    publicationPosts[i].Range = (int)distanceToUser;
                                    posts.Add(publicationPosts[i]);
                                }
                            }
                        }
                    }
                }
            }

            return posts;
        }

        /// <summary>
        /// Add Publication Id to favorites
        /// </summary>
        /// <param name="uId"></param>
        /// <param name="pId"></param>
        /// <returns></returns>
        public bool AddPublicationToFavorites(int uId, int pId)
        {
            bool result = false;
            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;


                cmd.CommandText = "INSERT INTO dbo.FavoritePublications(UserId, PublicationId) VALUES(@uId, @pId); SELECT @@Identity";
                cmd.Parameters.Add("@uId", SqlDbType.Int).Value = uId;
                cmd.Parameters.Add("@pId", SqlDbType.Int).Value = pId;
                cmd.ExecuteScalar();
                result = true;
            }
            return result;
        }

        internal bool deleteImage(int publicationId, ImageName image)
        {
            //if (FindById(post, id) == null)
            //{
            //    throw new Exception("Não existe post associado a este user!");
            //}

            if (image.Name == null || image.Name.Length == 0)
            {
                throw new Exception("Nome de imagem não enviado!");
            }

            try
            {
                ImageUploadHelper imageUploadHelper = new ImageUploadHelper();
                return imageUploadHelper.deletePostImage(publicationId, image.Name, "post");
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        internal bool deleteMainImage(int publicationId, ImageName image)
        {
            if (image.Name == null || image.Name.Length == 0)
            {
                throw new Exception("Nome de imagem não enviado!");
            }

            try
            {
                return imageUploadHelper.deletePostImage(publicationId, image.Name, "postMain");
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        /// <summary>
        /// Método que permite fazer upload de imagens para uma Publication
        /// </summary>
        /// <param name="id">id do post</param>
        /// <param name="images">coleção de imagens</param>
        /// <param name="mainImage">Imagem de destaque</param>
        /// <returns>Retorna os caminhos das imagens adicionadas</returns>
        public bool UploadImagesToPost(int id, IFormFileCollection images,
        IFormFile mainImage)
        {
            try
            {

                imageUploadHelper.UploadImage(mainImage, id, "postMain");
                string imagesPath = imageUploadHelper.UploadPostImages(images, id, "post");

                using (SqlCommand cmd = _connection.Fetch().CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText = "UPDATE dbo.[Publication]" +
                        "SET Image=@Ipath " +
                        "WHERE Id=@id";
                    cmd.Parameters.Add("@Ipath", SqlDbType.Int).Value = images.Count;
                    cmd.Parameters.Add("@id", SqlDbType.Int).Value = id;
                    cmd.ExecuteNonQuery();
                }

                return true;

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        /// <summary>
        /// Método que retorna uma lista com os nomes das imagens
        /// </summary>
        /// <param name="id">Id do post</param>
        /// <returns>Retorna lista com nomes de imagens</returns>
        public List<ImageName> getImages(int id)
        {
            try
            {

                return imageUploadHelper.getImages(id, "post");

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        /// <summary>
        /// Método que retorna o nome da imagem de destaque
        /// </summary>
        /// <param name="id">Id do post</param>
        /// <returns>Retorna o nome da Imagem de destaque</returns>
        public ImageName getMainImage(int id)
        {
            try
            {
                return imageUploadHelper.getMainImage(id, "postMain");
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
