using CloudStorageLibrary;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class DownloadExecutor : IDownloadExecutor
    {
        private readonly IStorage _storage;

        public DownloadExecutor(IStorage storage)
        {
            _storage = storage;
        }

        public Task<ExecutorResponse> DownloadPhotos(string tourId, string areaId, string outputDirectory)
        {
            try
            {
                if(!Directory.Exists(outputDirectory)) 
                    Directory.CreateDirectory(outputDirectory);

                var collectionName = Path.Combine("tours", tourId, areaId);

                // TODO: Download photos using _storage
            }
            catch (Exception ex)
            {
                return Task.FromResult(ExecutorResponse.Problem(ex.Message));
            }

            return Task.FromResult(ExecutorResponse.Ok());
        }
    }
}
