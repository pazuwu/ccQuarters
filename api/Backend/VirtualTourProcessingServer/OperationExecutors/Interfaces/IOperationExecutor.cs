
namespace VirtualTourProcessingServer.OperationExecutors.Interfaces
{
    public interface IOperationExecutor
    {
        Task<ExecutorResponse> Execute(ExecutorParameters parameters);
    }
}
