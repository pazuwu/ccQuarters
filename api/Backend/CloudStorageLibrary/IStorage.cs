namespace CloudStorageLibrary
{
    public interface IStorage
    {
        Task UploadFileAsync(string authToken, string collectionName, Stream stream, string fileName);
        Task DeleteFileAsync(string authToken, string collectionName, string fileName);
        Task<string> GetDownloadUrl(string authToken, string collectionName, string filename);
    }
}