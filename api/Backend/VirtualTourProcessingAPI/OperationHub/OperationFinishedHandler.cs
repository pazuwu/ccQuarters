using MediatR;
using VirtualTourProcessingServer.OperationRepository;

namespace VirtualTourProcessingServer.OperationHub
{
    internal class OperationFinishedHandler : INotificationHandler<OperationFinishedNotification>
    {
        private readonly IOperationHub _operationHub;
        private readonly IOperationRepository _operationRepository;

        public OperationFinishedHandler(IOperationHub operationHub, IOperationRepository repository)
        {
            _operationHub = operationHub;
            _operationRepository = repository;
        }

        public async Task Handle(OperationFinishedNotification notification, CancellationToken cancellationToken)
        {
            _operationHub.RunNext();

            if(notification.Operation.Stage == Model.OperationStage.Finished)
            {
                await _operationRepository.DeleteOperation(notification.Operation);
                return;
            }

            await _operationRepository.UpdateOperation(notification.Operation);
        }
    }
}
