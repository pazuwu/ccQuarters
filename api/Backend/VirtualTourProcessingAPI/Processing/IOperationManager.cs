using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationHub
{
    public interface IOperationManager
    {
        void RegisterNewOperations(IReadOnlyList<VTOperation> newOperations);
        void RunNext(OperationStage stage);
    }
}
