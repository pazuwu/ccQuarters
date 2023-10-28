using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationHub
{
    public interface IOperationHub
    {
        void RegisterNewOperations(IReadOnlyList<VTOperation> newOperations);
        void RunNext();
    }
}
