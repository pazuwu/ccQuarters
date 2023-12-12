using Dapper;
using Microsoft.Extensions.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;

namespace RepositoryLibrary
{
    public class RelationalDBRepository : IRelationalDBRepository, IDisposable
    {
        private readonly string connectionString;
        private List<IDbConnection> _connections = new();

        public RelationalDBRepository(IConfiguration config)
        {
            this.connectionString = config["db"] ?? "";

            if (string.IsNullOrEmpty(connectionString))
                connectionString = Environment.GetEnvironmentVariable("APPSETTING_RDB_CONNECTION_STRING") ?? "";
        }

        public RelationalDBRepository(string connectionString) 
        {
            this.connectionString = connectionString;
        }

        public async Task<int> ExecuteAsync(string sql, object? param = null, IDbTransaction? trans = null)
        {
            IDbConnection connection;
            if (trans?.Connection is not null)
                connection = trans!.Connection!;
            else if (_connections.Any())
                connection = _connections.First();
            else
            {
                connection = new SqlConnection(connectionString);
                _connections.Add(connection);
            }

            return await connection.ExecuteAsync(sql, param, trans);
        }

        public async Task<IEnumerable<T>> QueryAsync<T>(string sql, object? param = null, IDbTransaction? trans = null)
        {
            IDbConnection connection;
            if (trans?.Connection is not null)
                connection = trans!.Connection!;
            else if (_connections.Any())
                connection = _connections.First();
            else
            {
                connection = new SqlConnection(connectionString);
                _connections.Add(connection);
            }

            return await connection.QueryAsync<T>(sql, param, trans);
        }

        public async Task<T> QueryFirstAsync<T>(string sql, object? param = null, IDbTransaction? trans = null)
        {
            IDbConnection connection;
            if (trans?.Connection is not null)
                connection = trans!.Connection!;
            else if (_connections.Any())
                connection = _connections.First();
            else
            {
                connection = new SqlConnection(connectionString);
                _connections.Add(connection);
            }

            return await connection.QueryFirstAsync<T>(sql, param, trans);
        }

        public async Task<T?> QueryFirstOrDefaultAsync<T>(string sql, object? param = null, IDbTransaction? trans = null)
        {
            IDbConnection connection;
            if (trans?.Connection is not null)
                connection = trans!.Connection!;
            else if (_connections.Any())
                connection = _connections.First();
            else
            {
                connection = new SqlConnection(connectionString);
                _connections.Add(connection);
            }

            return await connection.QueryFirstOrDefaultAsync<T>(sql, param, trans);
        }

        public IDbTransaction BeginTransaction()
        {
            IDbConnection connection = new SqlConnection(connectionString);
            _connections.Add(connection);
           
            connection.Open();
            return connection.BeginTransaction();
        }

        public void CommitTransaction(IDbTransaction transaction)
        {
            transaction.Commit();
            transaction.Connection?.Close();
        }

        public void RollbackTransaction(IDbTransaction transaction)
        {
            transaction.Rollback();
            transaction.Connection?.Close();
        }

        public void Dispose()
        {
            foreach(var conn in _connections)
                conn?.Dispose();
            GC.SuppressFinalize(this);
        }
    }
}
