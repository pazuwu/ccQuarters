using CloudStorageLibrary;
using System.Collections.Concurrent;

namespace VirtualTourApi.IntegrationTests.Mocks
{
    internal class StorageMock : IStorage
    {
        private ConcurrentDictionary<string, string> _files = new();

        public Task DeleteFileAsync(string collectionName, string fileName)
        {
            _files.TryRemove(CreateKey(collectionName, fileName), out _);

            return Task.CompletedTask;
        }

        public Task<string> GetDownloadUrl(string collectionName, string filename)
        {
            if (_files.TryGetValue($"{collectionName}/{filename}", out var file))
                return Task.FromResult(file);

            return Task.FromResult(string.Empty);
        }

        public async Task<IEnumerable<string>> GetDownloadUrls(string collectionName, params string[] filenames)
        {
            var res = new List<string>();

            foreach (var filename in filenames)
            {
                res.Add(await GetDownloadUrl(collectionName, filename));
            }

            return res;
        }

        public Task UploadFileAsync(string collectionName, Stream stream, string fileName)
        {
            _files.TryAdd(CreateKey(collectionName, fileName), Guid.NewGuid().ToString());

            return Task.CompletedTask;
        }

        private string CreateKey(string collectionName, string filename) => $"{collectionName}/{filename}";
    }
}
