using MediatR;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Collections.Concurrent;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.OperationHub;

namespace VirtualTourProcessingServer.Postprocessing
{
    internal class PostprocessingRunner : IPostprocessingRunner
    {
        private readonly ConcurrentDictionary<VTOperation, Task?> _operations = new();
        private readonly ProcessingOptions _options;
        private readonly ILogger _logger;
        private readonly IMediator _mediator;

        public PostprocessingRunner(ILogger<PostprocessingRunner> logger, IOptions<ProcessingOptions> options, IMediator mediator)
        {
            _logger = logger;
            _options = options.Value;
            _mediator = mediator;
        }

        public bool TryRegister(VTOperation operation)
        {
            if (_operations.Count < _options.MaxPostprocessingThreads)
            {
                return _operations.TryAdd(operation, null);
            }

            return false;
        }

        public void Run(VTOperation operation)
        {
            if (_operations.ContainsKey(operation))
            {
                switch (operation.Stage)
                {
                    case OperationStage.SavingColmap:
                        _operations[operation] = SaveColmap(operation);
                        break;
                    case OperationStage.CleanupTrain:
                        _operations[operation] = CleanupTrain(operation);
                        break;
                    case OperationStage.SavingRender:
                        _operations[operation] = SaveRender(operation);
                        break;
                    case OperationStage.Finished:
                        _operations[operation] = CleanAll(operation);
                        break;
                    default:
                        break;
                }
            }

        }

        private Task SaveColmap(VTOperation operation)
        {
            _logger.LogInformation($"Saving COLMAP transforms for operation: {operation.OperationId}, areaId: {operation.AreaId}");
            FinishOperation(operation, new ExecutorResponse());
            return Task.CompletedTask;
        }

        private Task CleanupTrain(VTOperation operation)
        {
            _logger.LogInformation($"Cleaning trainig for operation: {operation.OperationId}, areaId: {operation.AreaId}");
            FinishOperation(operation, new ExecutorResponse());
            return Task.CompletedTask;
        }

        private Task SaveRender(VTOperation operation)
        {
            _logger.LogInformation($"Saving COLMAP transforms for operation: {operation.OperationId}, areaId: {operation.AreaId}");
            FinishOperation(operation, new ExecutorResponse());
            return Task.CompletedTask;
        }

        private Task CleanAll(VTOperation operation)
        {
            _logger.LogInformation($"Cleaning directory after completed operation: {operation.OperationId}, areaId: {operation.AreaId}");
            return Task.CompletedTask;
        }

        private Task FinishOperation(VTOperation operation, ExecutorResponse response)
        {
            if (response.Status == StatusCode.Error)
            {
                _logger.LogError(response.Message);
                operation.ProcessingAttempts++;
                operation.Status = OperationStatus.Error;
            }

            if (response.Status == StatusCode.Ok)
            {
                operation.ProcessingAttempts = 0;
                operation.Stage++;
            }


            var notification = _mediator.Publish(new OperationFinishedNotification(operation));
            CleanUpTasks();
            return notification;
        }

        private void CleanUpTasks()
        {
            List<VTOperation> operationsToRemove = new();

            foreach (var operationPair in _operations)
            {
                if (operationPair.Value?.IsCompleted ?? false)
                {
                    operationPair.Value.GetAwaiter().GetResult();
                    operationsToRemove.Add(operationPair.Key);
                }
            }

            foreach (var operationToRemove in operationsToRemove)
            {
                _operations.Remove(operationToRemove, out _);
            }
        }
    }
}
