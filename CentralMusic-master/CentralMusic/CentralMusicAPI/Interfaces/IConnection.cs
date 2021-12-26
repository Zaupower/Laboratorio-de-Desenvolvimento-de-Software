using System.Data.SqlClient;

namespace CentralMusicAPI.Interfaces
{
    public interface IConnection
    {
        SqlConnection Open();
        SqlConnection Fetch();
        void Close();
    }
}
