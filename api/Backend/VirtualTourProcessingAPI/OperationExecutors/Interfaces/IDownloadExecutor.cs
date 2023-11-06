namespace VirtualTourProcessingServer.OperationExecutors.Interfaces
{
    public interface IDownloadExecutor
    {
        Task<ExecutorResponse> DownloadPhotos(string tourId, string areaId, string outputDirectory);
    }
}
