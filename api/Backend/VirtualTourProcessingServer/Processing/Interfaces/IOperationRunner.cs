using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.Processing.Interfaces
{
    public interface IOperationRunner
    {
        bool TryRegister(VTOperation operation);
        void Run(VTOperation operation);
    }
}
