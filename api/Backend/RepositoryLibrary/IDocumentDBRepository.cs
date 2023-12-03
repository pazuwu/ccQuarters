using Google.Cloud.Firestore;

namespace RepositoryLibrary
{
    public interface IDocumentDBRepository
    {
        Task<string> SetAsync(string collectionName, string documentName, object values);
        Task<DocumentSnapshot?> GetAsync(string collectionName, string documentName);
        Task<string> DeleteAsync(string collectionName, string documentName);
    }
}
