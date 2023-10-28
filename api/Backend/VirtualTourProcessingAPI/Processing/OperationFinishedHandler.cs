using MediatR;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.OperationRepository;

namespace VirtualTourProcessingServer.OperationHub
{
    internal class OperationFinishedHandler : INotificationHandler<OperationFinishedNotification>
    {
        private readonly IOperationManager _operationManager;
        private readonly IOperationRepository _operationRepository;

        public OperationFinishedHandler(IOperationManager operationHub, IOperationRepository repository)
        {
            _operationManager = operationHub;
            _operationRepository = repository;
        }

        public async Task Handle(OperationFinishedNotification notification, CancellationToken cancellationToken)
        {
            _operationManager.RunNext(notification.Operation.Stage);
            await _operationRepository.UpdateOperation(notification.Operation);
        }
    }
}
