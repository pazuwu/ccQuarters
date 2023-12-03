using Dapper;
using Microsoft.Extensions.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace RepositoryLibrary
{
    public class RelationalDBRepository : IRelationalDBRepository, IDisposable
    {
        private readonly string connectionString;
        private IDbConnection? _connection;

        public RelationalDBRepository(IConfiguration config)
        {
            this.connectionString = config["db"] ?? "";
        }

        public async Task<int> ExecuteAsync(string sql, object? param = null, IDbTransaction? trans = null)
        {
            IDbConnection connection;
            if (trans?.Connection is not null)
                connection = trans!.Connection!;
            else if (_connection is not null)
                connection = _connection;
            else
                _connection = connection = new SqlConnection(connectionString);

            return await connection.ExecuteAsync(sql, param, trans);
        }

        public async Task<IEnumerable<T>> QueryAsync<T>(string sql, object? param = null, IDbTransaction? trans = null)
        {
            IDbConnection connection;
            if (trans?.Connection is not null)
                connection = trans!.Connection!;
            else if (_connection is not null)
                connection = _connection;
            else
                _connection = connection = new SqlConnection(connectionString);

            return await connection.QueryAsync<T>(sql, param, trans);
        }

        public async Task<T> QueryFirstAsync<T>(string sql, object? param = null, IDbTransaction? trans = null)
        {
            IDbConnection connection;
            if (trans?.Connection is not null)
                connection = trans!.Connection!;
            else if (_connection is not null)
                connection = _connection;
            else
                _connection = connection = new SqlConnection(connectionString);

            return await connection.QueryFirstAsync<T>(sql, param, trans);
        }

        public async Task<T?> QueryFirstOrDefaultAsync<T>(string sql, object? param = null, IDbTransaction? trans = null)
        {
            IDbConnection connection;
            if (trans?.Connection is not null)
                connection = trans!.Connection!;
            else if (_connection is not null)
                connection = _connection;
            else
                _connection = connection = new SqlConnection(connectionString);

            return await connection.QueryFirstOrDefaultAsync<T>(sql, param, trans);
        }

        public IDbTransaction BeginTransaction()
        {
            IDbConnection connection;
            if (_connection is not null)
                connection = _connection;
            else
                _connection = connection = new SqlConnection(connectionString);
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
            _connection?.Dispose();
            GC.SuppressFinalize(this);
        }
    }
}
