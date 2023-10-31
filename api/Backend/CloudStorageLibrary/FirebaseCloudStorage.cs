using Firebase.Storage;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;

namespace CloudStorageLibrary
{
    public class FirebaseCloudStorage : IStorage
    {
        private readonly string _bucketName;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public FirebaseCloudStorage(IConfiguration config, IHttpContextAccessor httpContextAccessor)
        {
            var bucketName = config["BucketName"];
            if (string.IsNullOrWhiteSpace(bucketName))
                throw new Exception("Storage BucketName is empty. Check your configuration file.");

            _bucketName = bucketName;
            _httpContextAccessor = httpContextAccessor;
        }

        private async Task<string> GetToken()
        {
            if(_httpContextAccessor.HttpContext != null)
                return await _httpContextAccessor.HttpContext.GetTokenAsync("access_token") ?? string.Empty;

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

        public async Task DeleteFileAsync(string authToken, string collectionName, string fileName)
        {
            var storage = new FirebaseStorage(_bucketName, new FirebaseStorageOptions()
            {
                AuthTokenAsyncFactory = GetToken
            });
            await storage.Child(collectionName)
                .Child(fileName)
                .DeleteAsync();
        }

        public async Task<string> GetDownloadUrl(string authToken, string collectionName, string filename)
        {
            var storage = new FirebaseStorage(_bucketName, new FirebaseStorageOptions()
            {
                AuthTokenAsyncFactory = GetToken
            });
            return await storage
                .Child(collectionName)
                .Child(filename)
                .GetDownloadUrlAsync();

        }

    }
}