namespace VirtualTourProcessingServer.OperationExecutors.Interfaces
{
    public class ColmapParameters
    {
        public required string InputDataPath { get; set; }
        public required string OutputDirectoryPath { get; set; }
    }

    public interface IColmapExecutor
    {
        Task<ExecutorResponse> Process(ColmapParameters parameters);
    }
}
