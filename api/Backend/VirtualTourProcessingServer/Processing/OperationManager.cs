using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.Processing.Interfaces;

namespace VirtualTourProcessingServer.Processing
{
    public delegate IOperationHub? HubResolver(OperationStage stage, IOperationHub operationHub, IOperationHub multiOperationHub);

    public class OperationManager : IOperationManager
    {
        private readonly IOperationHub _operationHub;
        private readonly IOperationHub _multiOperationHub;
        private readonly HubResolver _hubResolver;

        public OperationManager(ILogger<OperationManager> logger, IOptions<ProcessingOptions> options, 
            IMultiOperationRunner postprocessingRunner, IOperationRunner operationRunner, HubResolver hubResolver)
        {
            _operationHub = new OperationHub(logger, operationRunner, options);
            _multiOperationHub = new OperationHub(logger, postprocessingRunner, options);
            _hubResolver = hubResolver;
        }

        public void RegisterNewOperations(IReadOnlyList<VTOperation> newOperations)
        {
            foreach (var newOperation in newOperations)
            {
                var hub = _hubResolver(newOperation.Stage, _operationHub, _multiOperationHub);
                hub?.RegisterNewOperation(newOperation);
            }
        }

        public void RunNext(OperationStage stage)
        {
            var hub = _hubResolver(stage, _operationHub, _multiOperationHub);
            hub?.RunNext();
        }
    }
}
