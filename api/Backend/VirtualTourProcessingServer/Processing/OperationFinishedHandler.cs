using MediatR;
using Microsoft.Extensions.Logging;
using VirtualTourAPI.Client;
using VirtualTourAPI.Client.Parameters;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.Processing.Interfaces;
using OperationStage = VirtualTourProcessingServer.Model.OperationStage;
using VTAPIOperationStage = VirtualTourAPI.Client.Model.OperationStage;
using OperationStatus = VirtualTourProcessingServer.Model.OperationStatus;
using VTAPIOperationStatus = VirtualTourAPI.Client.Model.OperationStatus;

namespace VirtualTourProcessingServer.Processing
{
    public class OperationFinishedHandler : INotificationHandler<OperationFinishedNotification>
    {
        private readonly ILogger _logger;
        private readonly IOperationManager _operationManager;
        private readonly VTClient _client;

        public OperationFinishedHandler(ILogger<OperationFinishedHandler> logger, IOperationManager operationHub, VTClient client)
        {
            _logger = logger;
            _operationManager = operationHub;
            _client = client;
        }

        public async Task Handle(OperationFinishedNotification notification, CancellationToken cancellationToken)
        {
            var operation = notification.Operation;
            _logger.LogInformation($"Stage {operation.Stage} finished for {operation.OperationId}");
            _operationManager.RunNext(operation.Stage);

            if (notification.StatusCode == StatusCode.Error)
            {
                operation.ProcessingAttempts++;
                operation.Status = OperationStatus.Error;
            }
            else 
            {
                operation.ProcessingAttempts = 0;

                if (notification.Operation.Stage != OperationStage.Finished)
                    notification.Operation.Stage++;
            }


            var updateOperationParameters = new UpdateOperationParameters()
            {
                OperationId = notification.Operation.OperationId,
                Stage = MapStage(notification.Operation.Stage),
                ProcessingAttempts = notification.Operation.ProcessingAttempts,
                Status = notification.Operation.Status == OperationStatus.Ok ? VTAPIOperationStatus.Ok : VTAPIOperationStatus.Error,
            };

            await _client.Service.UpdateOperation(updateOperationParameters);
        }

        private static VTAPIOperationStage MapStage(OperationStage stage)
        {
            if(Enum.TryParse<VTAPIOperationStage>(stage.ToString(), out var operationStage))
            {
                return operationStage;
            }

            return VTAPIOperationStage.Finished;
        }
    }
}
