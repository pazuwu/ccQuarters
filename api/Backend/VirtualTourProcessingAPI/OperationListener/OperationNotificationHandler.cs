using MediatR;
using VirtualTourProcessingServer.OperationHub;

namespace VirtualTourProcessingServer.Services
{
    public class OperationNotificationHandler : INotificationHandler<OperationNotification>
    {
        private readonly IOperationHub _operationHub;

        public OperationNotificationHandler(IOperationHub operationHub)
        {
            _operationHub = operationHub;
        }

        public Task Handle(OperationNotification notification, CancellationToken cancellationToken)
        {
            _operationHub.RegisterNewOperations(notification.Operations);
            return Task.CompletedTask;
        }
    }
}
