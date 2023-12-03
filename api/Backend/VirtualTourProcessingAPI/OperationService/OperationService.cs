using RepositoryLibrary;
using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationService
{
    public class OperationService : IOperationService
    {
        private const string CollectionName = "operations";
        private readonly IDocumentDBRepository documentRepository;

        public OperationService(IDocumentDBRepository documentRepository)
        {
            this.documentRepository = documentRepository;
        }

        public async Task DeleteOperation(VTOperation operation)
        {
            await documentRepository.DeleteAsync($"{CollectionName}/{operation.OperationId}");
        }

        public async Task UpdateOperation(VTOperation operation)
        {
            var fieldsToUpdate = new Dictionary<string, object>
            {
                { nameof(operation.Stage), operation.Stage.ToString() },
                { nameof(operation.Status), operation.Status.ToString() },
                { nameof(operation.ProcessingAttempts), operation.ProcessingAttempts },
            };

            await documentRepository.SetAsync($"{CollectionName}/{operation.OperationId}", fieldsToUpdate);
        }
    }
}
