using AutoMapper;
using CentralMusicAPI.Entities;
using CentralMusicAPI.Models.Users;

namespace CentralMusicAPI.Configs
{
    /// <summary>
    /// Classe para fazer mapeamento entre modelos
    /// </summary>
    public class AutoMapperProfile : Profile
    {
        /// <summary>
        /// Método que contém os modelos para os quais são mapeados
        /// </summary>
        public AutoMapperProfile()
        {

            CreateMap<UserRegister, User>();
            CreateMap<User, UserRegister>();

            CreateMap<UserModel, User>();
            CreateMap<User, UserModel>();

            CreateMap<UserRegister, UserModel>();
            CreateMap<UserModel, UserRegister>();

            CreateMap<UserUpdateProfile, User>();
            CreateMap<User, UserUpdateProfile>();

            CreateMap<UserUpdatePassword, User>();
            CreateMap<User, UserUpdatePassword>();
        }
    }
}