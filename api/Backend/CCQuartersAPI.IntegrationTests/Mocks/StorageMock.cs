using CloudStorageLibrary;
using Google.Cloud.Firestore;
using RepositoryLibrary;

namespace CCQuartersAPI.IntegrationTests.Mocks
{
    internal class StorageMock : IStorage
    {
        public async Task DeleteFileAsync(string collectionName, string fileName)
        {
            return;
        }

        public async Task<string> GetDownloadUrl(string collectionName, string filename)
        {
            return string.Empty;
        }

        public async Task<IEnumerable<string>> GetDownloadUrls(string collectionName, params string[] filenames)
        {
            return Enumerable.Empty<string>();
        }

        public async Task UploadFileAsync(string collectionName, Stream stream, string fileName)
        {
            return;
        }
    }
}
