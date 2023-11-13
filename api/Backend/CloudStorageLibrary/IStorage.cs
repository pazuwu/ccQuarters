namespace CloudStorageLibrary
{
    public interface IStorage
    {
        Task UploadFileAsync(string collectionName, Stream stream, string fileName);
        Task DeleteFileAsync(string collectionName, string fileName);
        Task<IEnumerable<string>> GetDownloadUrl(string collectionName, params string[] filenames);
    }
}