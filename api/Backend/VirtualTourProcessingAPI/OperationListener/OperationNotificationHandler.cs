using MediatR;
using VirtualTourProcessingServer.Processing.Interfaces;

namespace VirtualTourProcessingServer.Services
{
    public class OperationNotificationHandler : INotificationHandler<OperationNotification>
    {
        private readonly IOperationManager _operationManager;

        public OperationNotificationHandler(IOperationManager operationManager)
        {
            _operationManager = operationManager;
        }

        public Task Handle(OperationNotification notification, CancellationToken cancellationToken)
        {
            _operationManager.RegisterNewOperations(notification.Operations);
            return Task.CompletedTask;
        }
    }
}
