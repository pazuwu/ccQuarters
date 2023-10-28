using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationHub
{
    public interface IOperationHub
    {
        void RegisterNewOperations(IReadOnlyList<VTOperation> newOperation);
        void RunNext();
    }
}
