using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationHub
{
    public class OperationHub : IOperationHub
    {
        private readonly PriorityQueue<VTOperation, OperationPriority> _operationQueue = new();

        private readonly ILogger<OperationHub> _logger;
        private readonly IOperationRunner _operationRunner;
        private readonly ProcessingOptions _processingOptions;

        public OperationHub(ILogger<OperationHub> logger, IOperationRunner operationRunner, IOptions<ProcessingOptions> processingOptions)
        {
            _logger = logger;
            _operationRunner = operationRunner;
            _processingOptions = processingOptions.Value;
        }

        public void RegisterNewOperations(IReadOnlyList<VTOperation> newOperations)
        {
            foreach (var operation in newOperations)
            {
                if (operation.ProcessingAttempts >= _processingOptions.MaxProcessingAttempts)
                    continue;

                var priority = new OperationPriority(operation.LastModified, operation.Stage);

                lock (_operationQueue)
                {
                    _operationQueue.Enqueue(operation, priority);
                }

                _logger.LogInformation("New operation has been registered: {0}, status: {1}", operation.OperationId, operation.Stage);
            }

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
                        _operationRunner.Run();
                    }
                }
            }
        }
    }
}
