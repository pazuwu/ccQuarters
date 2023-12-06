using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.Processing.Interfaces;

namespace VirtualTourProcessingServer.Processing
{
    public class OperationHub : IOperationHub
    {
        private readonly PriorityQueue<VTOperation, OperationPriority> _operationQueue = new();

        private readonly ILogger _logger;
        private readonly IOperationRunner _operationRunner;
        private readonly ProcessingOptions _processingOptions;

        public OperationHub(ILogger logger, IOperationRunner operationRunner, IOptions<ProcessingOptions> processingOptions)
        {
            _logger = logger;
            _operationRunner = operationRunner;
            _processingOptions = processingOptions.Value;
        }

        public void RegisterNewOperation(VTOperation operation)
        {
            if (operation.ProcessingAttempts >= _processingOptions.MaxProcessingAttempts)
                return;

            var priority = new OperationPriority(operation.LastModified, operation.Stage);

            lock (_operationQueue)
            {
                _operationQueue.Enqueue(operation, priority);
            }

            _logger.LogInformation("New operation has been registered: {0}, stage: {1}", operation.OperationId, operation.Stage);

            RunNext();
        }

        public void RunNext()
        {
            lock (_operationQueue)
            {
                if (_operationQueue.Count > 0)
                {
                    var nextOperation = _operationQueue.Peek();

                    if (_operationRunner.TryRegister(nextOperation))
                    {
                        _operationQueue.Dequeue();
                        _operationRunner.Run(nextOperation);
                    }
                }
            }
        }
    }
}
