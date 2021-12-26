using CentralMusicAPI.Configs;
using CentralMusicAPI.Interfaces;
using Microsoft.Extensions.Options;
using System;
using System.Data;
using System.Data.SqlClient;

namespace CentralMusicAPI.Data_Access
{

    public class Connection : IConnection, IDisposable
    {
        private SqlConnection _connection;

        public Connection(IOptions<AppSettings> config)
        {
            _connection = new SqlConnection(config.Value.DBConnection);
        }

        public void Close()
        {
            if (_connection.State == ConnectionState.Open)
            {
                _connection.Close();
            }
        }

        public void Dispose()
        {
            this.Close();
            GC.SuppressFinalize(this);
        }

        public SqlConnection Fetch()
        {
            return this.Open();
        }

        public SqlConnection Open()
        {
            if (_connection.State == ConnectionState.Closed)
            {
                _connection.Open();
            }
            return _connection;
        }
    }
}
