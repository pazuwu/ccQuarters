using Google.Cloud.Firestore;
using Microsoft.Extensions.Options;
using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationRepository
{
    public class OperationRepository : IOperationRepository
    {
        private const string CollectionName = "operations";
        private readonly FirestoreDb _firestore;

        public OperationRepository(IOptions<DocumentDBOptions> options)
        {
            if (string.IsNullOrWhiteSpace(options.Value.ProjectId))
                throw new Exception("DocumentDB ProjectId is empty. Check your configuration file.");

            _firestore = FirestoreDb.Create(options.Value.ProjectId);
        }

        public async Task DeleteOperation(VTOperation operation)
        {
            var collection = _firestore.Collection(CollectionName);
            var documentRef = collection.Document(operation.OperationId);

            await documentRef.DeleteAsync();
        }

        public async Task UpdateOperation(VTOperation operation)
        {
            var collection = _firestore.Collection(CollectionName);
            var documentRef = collection.Document(operation.OperationId);

            var fieldsToUpdate = new Dictionary<string, object> 
            {
                { nameof(operation.Stage), operation.Stage.ToString() },
                { nameof(operation.Status), operation.Status.ToString() },
                { nameof(operation.ProcessingAttempts), operation.ProcessingAttempts },
            };

            await documentRef.UpdateAsync(fieldsToUpdate);
        }
    }
}
