using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationRepository
{
    public interface IOperationRepository
    {
        Task UpdateOperation(VTOperation operation);
        Task DeleteOperation(VTOperation operation);
    }
}
