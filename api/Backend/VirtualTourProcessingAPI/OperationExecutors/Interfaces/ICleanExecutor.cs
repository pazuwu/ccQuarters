
namespace VirtualTourProcessingServer.OperationExecutors.Interfaces
{
    public interface ICleanExecutor
    {
        Task<ExecutorResponse> CleanWorkingDirectory(string path);
    }
}
