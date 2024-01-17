using VirtualTourAPI.DTOModel;

namespace VirtualTourAPI.Services.Interfaces
{
    public interface IOperationService
    {
        Task<string?> CreateOperation(string tourId, string operationId);
        Task UpdateOperation(string tourId, string operationId, VTOperationUpdateDTO operationUpdate);
        Task DeleteOperation(string tourId, string operationId);
    }
}
