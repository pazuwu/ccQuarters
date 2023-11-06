using CloudStorageLibrary;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class DownloadExecutor : IDownloadExecutor
    {
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
