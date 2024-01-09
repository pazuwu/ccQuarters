﻿using MediatR;
using Microsoft.Extensions.Logging;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.OperationService;
using VirtualTourProcessingServer.Processing.Interfaces;

namespace VirtualTourProcessingServer.Processing
{
    public class OperationFinishedHandler : INotificationHandler<OperationFinishedNotification>
    {
        private readonly ILogger _logger;
        private readonly IOperationManager _operationManager;
        private readonly IOperationService _operationRepository;

        public OperationFinishedHandler(ILogger<OperationFinishedHandler> logger, IOperationManager operationHub, IOperationService repository)
        {
            _logger = logger;
            _operationManager = operationHub;
            _operationRepository = repository;
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
                else
                {
                    await _operationRepository.DeleteOperation(operation);
                    return;
                }
            }

            await _operationRepository.UpdateOperation(notification.Operation);
        }
    }
}
