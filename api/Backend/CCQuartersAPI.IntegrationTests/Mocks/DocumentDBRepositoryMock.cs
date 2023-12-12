using Google.Cloud.Firestore;
using RepositoryLibrary;

namespace CCQuartersAPI.IntegrationTests.Mocks
{
    internal class DocumentDBRepositoryMock : IDocumentDBRepository
    {
        public async Task<string> AddAsync(string collectionPath, object values)
        {
            return string.Empty;
        }

        public async Task<string> DeleteAsync(string documentPath)
        {
            return string.Empty;
        }

        public async Task<DocumentSnapshot?> GetAsync(string documentPath)
        {
            return null;
        }

        public async Task<IEnumerable<DocumentSnapshot>?> GetByFieldAsync(string collectionPath, string field, object value)
        {
            return Enumerable.Empty<DocumentSnapshot>();
        }

        public async Task<IEnumerable<DocumentSnapshot>?> GetCollectionAsync(string collectionPath)
        {
            return null;
        }

        public async Task<long?> GetCountByFieldAsync(string collectionPath, string field, object value)
        {
            return 0;
        }

        public async Task<string> SetAsync(string documentPath, object values)
        {
            return string.Empty;
        }

        public async Task UpdateAsync(string documentPath, string fieldName, object value)
        {
            return;
        }
    }
}
