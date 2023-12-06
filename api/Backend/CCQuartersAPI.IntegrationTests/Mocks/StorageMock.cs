using CloudStorageLibrary;

namespace CCQuartersAPI.IntegrationTests.Mocks
{
    internal class StorageMock : IStorage
    {
        public Task DeleteFileAsync(string collectionName, string fileName)
        {
            return Task.CompletedTask;
        }

        public Task<string> GetDownloadUrl(string collectionName, string filename)
        {
            return Task.FromResult(string.Empty);
        }

        public Task<IEnumerable<string>> GetDownloadUrls(string collectionName, params string[] filenames)
        {
            return Task.FromResult(Enumerable.Empty<string>());
        }

        public Task UploadFileAsync(string collectionName, Stream stream, string fileName)
        {
            return Task.CompletedTask;
        }
    }
}
