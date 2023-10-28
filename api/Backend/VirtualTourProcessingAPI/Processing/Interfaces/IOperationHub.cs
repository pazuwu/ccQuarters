using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.Processing.Interfaces
{
    public interface IOperationHub
    {
        void RegisterNewOperation(VTOperation newOperations);
        void RunNext();
    }
}
