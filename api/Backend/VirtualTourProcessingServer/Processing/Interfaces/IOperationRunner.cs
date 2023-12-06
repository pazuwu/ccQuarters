using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.Processing.Interfaces
{
    public interface IOperationRunner
    {
        bool TryRegister(VTOperation operation);
        void Run(VTOperation operation);
    }
}
