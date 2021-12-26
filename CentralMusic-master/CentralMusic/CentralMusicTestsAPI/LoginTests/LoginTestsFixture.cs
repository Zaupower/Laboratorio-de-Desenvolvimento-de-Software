using CentralMusicAPI.Configs;
using CentralMusicAPI.Data_Access;
using Microsoft.Extensions.Options;
using System;
using System.Data;
using System.Data.SqlClient;

namespace CentralMusicTestsAPI.LoginTests
{
    class LoginTestsFixture
    {
        private AppSettings _appSettings;
        private Connection _connection;
        public LoginTestsFixture()
        {
            _appSettings = new AppSettings();
            //Change this string to your local DB and server!
            _appSettings.DBConnection = "Server=tcp:centralmusic.database.windows.net,1433;Initial Catalog=CentralTests;Persist Security Info=False;User ID=Samuel;Password=Centralmusic6;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
            IOptions<AppSettings> options = Options.Create<AppSettings>(_appSettings);
            _connection = new Connection(options);

            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;

                cmd.CommandText = "DELETE FROM dbo.[UserChat];" +
                "DELETE FROM dbo.[Message];" +
                "DELETE FROM dbo.[Chat];" +
                "DELETE FROM dbo.[Publication];" +
                "DELETE FROM dbo.[FavoritePublications];" +
                "DELETE FROM dbo.[User];";

                cmd.ExecuteScalar();
            }
        }

        ~LoginTestsFixture()
        {
            Dispose();
        }

        public void Dispose()
        {
            GC.SuppressFinalize(this);
            using (SqlCommand cmd = _connection.Fetch().CreateCommand())
            {
                cmd.CommandType = CommandType.Text;

                cmd.CommandText = "DELETE FROM dbo.[UserChat];" +
                "DELETE FROM dbo.[Message];" +
                "DELETE FROM dbo.[Chat];" +
                "DELETE FROM dbo.[Publication];" +
                "DELETE FROM dbo.[FavoritePublications];" +
                "DELETE FROM dbo.[User];";

                cmd.ExecuteScalar();
            }
        }

        public Connection GetConnection()
        {
            return _connection;
        }
    }
}
