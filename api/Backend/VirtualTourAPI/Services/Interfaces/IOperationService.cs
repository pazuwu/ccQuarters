using VirtualTourAPI.DTOModel;

namespace VirtualTourAPI.Services.Interfaces
{
    public interface IOperationService
    {
        Task<string?> CreateOperation(string tourId, string operationId, string userEmail);
        Task UpdateOperation(string operationId, VTOperationUpdateDTO operationUpdate);
        Task DeleteOperation(string operationId);
    }
}
