using Google.Cloud.Firestore;
using MediatR;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.OperationListener;

namespace VirtualTourProcessingServer.Services
{
    public class OperationListener : IHostedService
    {
        private readonly IMediator _mediator;
        private readonly FirestoreDb _firestore;
        private FirestoreChangeListener? _listener;

        public OperationListener(IMediator mediator, IOptions<DocumentDBOptions> options)
        {
            if (string.IsNullOrWhiteSpace(options.Value.ProjectId))
                throw new Exception("DocumentDB ProjectId is empty. Check your configuration file.");

            _mediator = mediator;
            _firestore = FirestoreDb.Create(options.Value.ProjectId);
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            var collectionRef = _firestore.Collection("operations");
            _listener = collectionRef.Listen(OperationsDBUpdateHandler);

            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            return _listener?.StopAsync(cancellationToken) ?? Task.CompletedTask;
        }

        private Task OperationsDBUpdateHandler(QuerySnapshot snapshot, CancellationToken token)
        {
            if(snapshot.Changes.Any())
            {
                List<VTOperation> operations = new List<VTOperation>();

                foreach (var change in snapshot.Changes)
                {
                    if(change is not null && (change.ChangeType == DocumentChange.Type.Added || change.ChangeType == DocumentChange.Type.Modified))
                    {
                        var operation = change.Document.ConvertTo<VTOperation>();
                        operations.Add(operation);
                    }
                }

                return _mediator.Publish(new OperationNotification(operations));
            }

            return Task.CompletedTask;
        }
    }
}
