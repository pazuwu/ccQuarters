using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.Processing.Interfaces
{
    public interface IOperationManager
    {
        void RegisterNewOperations(IReadOnlyList<VTOperation> newOperations);
        void RunNext(OperationStage stage);
    }
}
