namespace VirtualTourProcessingServer.OperationExecutors.Interfaces
{
    public class UploadExecutorParameters
    {
        public required string TourId { get; set; }
        public required string AreaId { get; set; }
        public required string DirectoryPath { get; set; }
    }

    public interface IUploadExecutor
    {
        public Task<ExecutorResponse> SaveScenes(UploadExecutorParameters parameters);
    }
}
