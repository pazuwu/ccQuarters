using Google.Cloud.Firestore;
using MediatR;
using Microsoft.Extensions.Hosting;
using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.Services
{
    public class OperationListener : IHostedService
    {
        IMediator _mediator;
        FirestoreChangeListener? _listener;

        public OperationListener(IMediator mediator)
        {
            _mediator = mediator;
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            var firestore = FirestoreDb.Create("ccquartersmini");
            var collectionRef = firestore.Collection("operations");
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
                    if(change is not null && change.ChangeType == DocumentChange.Type.Added)
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
