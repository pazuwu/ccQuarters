using MediatR;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Collections.Concurrent;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;
using VirtualTourProcessingServer.Processing.Interfaces;

namespace VirtualTourProcessingServer.Processing
{
    public delegate IOperationExecutor? MultiExecutorResolver(OperationStage stage);

    public class MultiOperationRunner : IMultiOperationRunner
    {
        private readonly ConcurrentDictionary<VTOperation, Task?> _operations = new();
        private readonly ProcessingOptions _options;
        private readonly ILogger _logger;
        private readonly IMediator _mediator;
        private readonly MultiExecutorResolver _executorResolver;

        public MultiOperationRunner(ILogger<MultiOperationRunner> logger, IOptions<ProcessingOptions> options, IMediator mediator, MultiExecutorResolver resolver)
        {
            _logger = logger;
            _options = options.Value;
            _mediator = mediator;
            _executorResolver = resolver;
        }

        public bool TryRegister(VTOperation operation)
        {
            if(_operations.Count >= _options.MaxMultiprocessingThreads * 0.8)
            {
                CleanUpTasks();
            }

            if (_operations.Count < _options.MaxMultiprocessingThreads)
            {
                return _operations.TryAdd(operation, null);
            }

            return false;
        }

        public void Run(VTOperation operation)
        {
            if (_operations.ContainsKey(operation))
            {
                var executor = _executorResolver(operation.Stage);

                if(executor != null)
                {
                    _operations[operation] = Task.Run(() => RunExecutor(operation, executor));
                    return;
                }
            }

        }

        private async Task RunExecutor(VTOperation operation, IOperationExecutor executor)
        {
            var executorParameters = new ExecutorParameters()
            {
                Operation = operation,
                AreaDirectory = Path.Combine(_options.StorageDirectory!, operation.TourId, operation.AreaId),
                TourDirectory = Path.Combine(_options.StorageDirectory!, operation.TourId)
            };

            var response = await executor.Execute(executorParameters);
            await FinishOperation(operation, response);
        }

        private async Task FinishOperation(VTOperation operation, ExecutorResponse response)
        {
            if (response.Status == StatusCode.Error)
            {
                _logger.LogError(response.Message);
            }

            CleanUpTasks();
            await _mediator.Publish(new OperationFinishedNotification(operation, response.Status));
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
