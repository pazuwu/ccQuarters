namespace VirtualTourProcessingServer.OperationExecutors
{
    public class TrainParameters
    {
        public string? DataDirectoryPath { get; set; }
        public string? OutputDirectoryPath { get; set; } 
    }

    public interface ITrainExecutor
    {
        Task<ExecutorResponse> Train(TrainParameters parameters);
    }
}
