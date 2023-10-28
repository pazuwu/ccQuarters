using Microsoft.Extensions.Logging;
using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationHub
{
    public class OperationHub : IOperationHub
    {
        private readonly PriorityQueue<VTOperation, OperationPriority> _operationQueue = new();

        private readonly ILogger<OperationHub> _logger;
        private readonly IOperationRunner _operationRunner;

        public OperationHub(ILogger<OperationHub> logger, IOperationRunner operationRunner)
        {
            _logger = logger;
            _operationRunner = operationRunner;

            _operationRunner.OperationFinished += OperationFinishedHandler;
        }

        public void RegisterNewOperations(IReadOnlyList<VTOperation> newOperations)
        {
            foreach (var operation in newOperations)
            {
                var priority = new OperationPriority(operation.LastModified, operation.Status);

                lock (_operationQueue)
                {
                    _operationQueue.Enqueue(operation, priority);
                }

                _logger.LogInformation($"New operation has been registered: {operation.OperationId}, status: {operation.Status}");
            }

            RunNext();
        }

        private void RunNext()
        {
            lock (_operationQueue)
            {
                if (_operationQueue.Count > 0)
                {
                    var nextOperation = _operationQueue.Dequeue();
                    _operationRunner.TryRun(nextOperation);
                }
            }
        }

        private void OperationFinishedHandler()
        {
            RunNext();
        }
    }
}
