using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationHub
{
    public interface IOperationRunner
    {
        event Action OperationFinished;
        bool TryRun(VTOperation operation);
    }
}
