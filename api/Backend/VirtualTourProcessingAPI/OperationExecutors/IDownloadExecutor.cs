
namespace VirtualTourProcessingServer.OperationExecutors
{
    public interface IDownloadExecutor
    {
        Task<ExecutorResponse> DownloadPhotos(string tourId, string areaId, string outputDirectory);
    }
}
