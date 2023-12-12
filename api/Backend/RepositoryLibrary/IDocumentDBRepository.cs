using Google.Cloud.Firestore;

namespace RepositoryLibrary
{
    public interface IDocumentDBRepository
    {
        Task<string> SetAsync(string documentPath, object values);
        Task<DocumentSnapshot?> GetAsync(string documentPath);
        Task<IEnumerable<DocumentSnapshot>?> GetByFieldAsync(string collectionPath, string field, object value);
        Task<IEnumerable<DocumentSnapshot>?> GetCollectionAsync(string collectionPath);
        Task<string> DeleteAsync(string documentPath);
        Task<string> AddAsync(string collectionPath, object values);
        Task UpdateAsync(string documentPath, string fieldName, object value);
        Task<long?> GetCountByFieldAsync(string collectionPath, string field, object value);
    }
}
