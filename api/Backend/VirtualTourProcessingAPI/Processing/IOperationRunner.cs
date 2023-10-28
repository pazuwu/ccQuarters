using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationHub
{
    public interface IOperationRunner
    {
        bool TryRegister(VTOperation operation);
        void Run(VTOperation operation);
    }
}
