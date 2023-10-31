using Firebase.Storage;
using Microsoft.Extensions.Configuration;
using System.Text;

namespace CloudStorageLibrary
{
    public class FirebaseCloudStorage : IStorage
    {
        private readonly string _bucketName;

        public FirebaseCloudStorage(IConfiguration config)
        {
            _bucketName = config["BucketName"];
        }

        public async Task UploadFileAsync(string authToken, string collectionName, Stream stream, string fileName)
        {
            var storage = new FirebaseStorage(_bucketName, new FirebaseStorageOptions()
            {
                AuthTokenAsyncFactory = () => Task.FromResult(authToken)
            });
            await storage.Child(collectionName)
                .Child(fileName)
                .PutAsync(stream);
        }

        public async Task DeleteFileAsync(string authToken, string collectionName, string fileName)
        {
            var storage = new FirebaseStorage(_bucketName, new FirebaseStorageOptions()
            {
                AuthTokenAsyncFactory = () => Task.FromResult(authToken)
            });
            await storage.Child(collectionName)
                .Child(fileName)
                .DeleteAsync();
        }

        public async Task<string> GetDownloadUrl(string authToken, string collectionName, string filename)
        {
            var storage = new FirebaseStorage(_bucketName, new FirebaseStorageOptions()
            {
                AuthTokenAsyncFactory = () => Task.FromResult(authToken)
            });
            return await storage
                .Child(collectionName)
                .Child(filename)
                .GetDownloadUrlAsync();

        }

    }
}