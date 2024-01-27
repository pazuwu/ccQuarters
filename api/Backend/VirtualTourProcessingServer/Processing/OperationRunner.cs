using MediatR;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;
using VirtualTourProcessingServer.Processing.Interfaces;

namespace VirtualTourProcessingServer.Processing
{
    public delegate IOperationExecutor? ExecutorResolver(OperationStage stage);

    public class OperationRunner : IOperationRunner
    {
        private readonly IMediator _mediator;
        private readonly ILogger<OperationRunner> _logger;
        private readonly ProcessingOptions _options;
        private readonly ExecutorResolver _executorResolver;

        private VTOperation? _runningOperation;
        private Task<ExecutorResponse>? _runningTask;

        public OperationRunner(ILogger<OperationRunner> logger, IMediator mediator, IOptions<ProcessingOptions> options, ExecutorResolver resolver)
        {
            _mediator = mediator;
            _logger = logger;
            _options = options.Value;
            _executorResolver = resolver;
        }

        public bool TryRegister(VTOperation operation)
        {
            if (_runningOperation == null)
            {
                _runningTask?.GetAwaiter().GetResult();
                _runningOperation = operation;
                return true;
            }

            return false;
        }

        public void Run(VTOperation operation)
        {
            if (_runningOperation == null)
                return;

            var executor = _executorResolver(operation.Stage);

            if(executor != null)
            {
                _runningTask = Task.Run(() => RunExecutor(operation, executor));
                _runningTask.ContinueWith((task) => FinishOperation(operation, task.Result));
                return;
            }
        }

        private async Task<ExecutorResponse> RunExecutor(VTOperation operation, IOperationExecutor executor)
        {
            var executorParameters = new ExecutorParameters()
            {
                Operation = operation,
                AreaDirectory = Path.Combine(_options.StorageDirectory!, operation.TourId, operation.AreaId),
                TourDirectory = Path.Combine(_options.StorageDirectory!, operation.TourId)
            };

            return await executor.Execute(executorParameters);
        }

        private Task FinishOperation(VTOperation operation, ExecutorResponse response)
        {
            if (response.Status == StatusCode.Error)
            {
                _logger.LogError(response.Message);
            }

            _runningOperation = null;
            return _mediator.Publish(new OperationFinishedNotification(operation, response.Status));
        }
    }
}
