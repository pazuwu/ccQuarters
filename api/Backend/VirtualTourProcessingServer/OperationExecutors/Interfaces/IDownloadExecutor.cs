namespace VirtualTourProcessingServer.OperationExecutors.Interfaces
{
    public class DownloadParameters
    {
        public required string TourId { get; set; }
        public required string AreaId { get; set; }
        public required string OutputDirectory { get; set; }
    }

    public interface IDownloadExecutor
    {
        Task<ExecutorResponse> DownloadPhotos(DownloadParameters parameters);
    }
}
