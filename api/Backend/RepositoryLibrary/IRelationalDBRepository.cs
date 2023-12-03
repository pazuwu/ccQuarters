using System.Data;

namespace RepositoryLibrary
{
    public interface IRelationalDBRepository
    {
        Task<IEnumerable<T>> QueryAsync<T>(string sql, object? param = null, IDbTransaction? transaction = null);
        Task<T> QueryFirstAsync<T>(string sql, object? param = null, IDbTransaction? transaction = null);
        Task<T?> QueryFirstOrDefaultAsync<T>(string sql, object? param = null, IDbTransaction? transaction = null);
        Task<int> ExecuteAsync(string sql, object? param = null, IDbTransaction? transaction = null);


        IDbTransaction BeginTransaction();
        void CommitTransaction(IDbTransaction transaction);
        void RollbackTransaction(IDbTransaction transaction);
    }
}
