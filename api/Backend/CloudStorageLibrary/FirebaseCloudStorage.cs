using AuthLibrary;
using Firebase.Storage;
using Microsoft.Extensions.Configuration;

namespace CloudStorageLibrary
{
    public class FirebaseCloudStorage : IStorage
    {
        private readonly string _bucketName;
        private readonly ITokenProvider _tokenProvider;

        public FirebaseCloudStorage(IConfiguration config, ITokenProvider tokenProvider)
        {
            var bucketName = config["BucketName"];
            if (string.IsNullOrWhiteSpace(bucketName))
                throw new Exception("Storage BucketName is empty. Check your configuration file.");

            _bucketName = bucketName;
            _tokenProvider = tokenProvider;
        }

        private async Task<string> GetToken()
        {
            string userToken = await _tokenProvider.GetUserToken();
            if (!string.IsNullOrWhiteSpace(userToken))
                return userToken;

            string serverToken = await _tokenProvider.GetServerToken();
            if (!string.IsNullOrWhiteSpace(serverToken))
                return serverToken;

            return string.Empty;
        }

        public async Task UploadFileAsync(string collectionName, Stream stream, string fileName)
        {
            var storage = new FirebaseStorage(_bucketName, new FirebaseStorageOptions()
            {
                AuthTokenAsyncFactory = GetToken
            });
            await storage.Child(collectionName)
                .Child(fileName)
                .PutAsync(stream);
        }

        public async Task DeleteFileAsync(string collectionName, string fileName)
        {
            var storage = new FirebaseStorage(_bucketName, new FirebaseStorageOptions()
            {
                AuthTokenAsyncFactory = GetToken
            });
            await storage.Child(collectionName)
                .Child(fileName)
                .DeleteAsync();
        }

        public async Task<string> GetDownloadUrl(string collectionName, string filename)
        {
            var storage = new FirebaseStorage(_bucketName, new FirebaseStorageOptions()
            {
                AuthTokenAsyncFactory = GetToken
            });

            try
            {
                return await storage
                     .Child(collectionName)
                     .Child(filename)
                     .GetDownloadUrlAsync();
            }
            catch
            {
                return string.Empty;
            }
        }

        public async Task<IEnumerable<string>> GetDownloadUrls(string collectionName, params string[] filenames)
        {
            var storage = new FirebaseStorage(_bucketName, new FirebaseStorageOptions()
            {
                AuthTokenAsyncFactory = GetToken
            });
            
            var tasks = new List<Task<string>>(filenames.Length);

            foreach (var filename in filenames)
                tasks.Add(storage
                 .Child(collectionName)
                 .Child(filename)
                 .GetDownloadUrlAsync());

            await Task.WhenAll(tasks);

            return tasks.Select(t => t.GetAwaiter().GetResult()).ToList();
        }

    }
}