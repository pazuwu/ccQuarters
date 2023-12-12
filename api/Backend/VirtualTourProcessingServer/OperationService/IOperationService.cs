using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationService
{
    public interface IOperationService
    {
        Task UpdateOperation(VTOperation operation);
        Task DeleteOperation(VTOperation operation);
    }
}
