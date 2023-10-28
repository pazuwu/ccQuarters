using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.Processing.Interfaces;

namespace VirtualTourProcessingServer.Processing
{
    internal class OperationManager : IOperationManager
    {
        private readonly IOperationHub _operationHub;
        private readonly IOperationHub _multiOperationHub;

        public OperationManager(ILogger<OperationManager> logger, IOptions<ProcessingOptions> options, 
            IMultiOperationRunner postprocessingRunner, IOperationRunner operationRunner)
        {
            _operationHub = new OperationHub(logger, operationRunner, options);
            _multiOperationHub = new OperationHub(logger, postprocessingRunner, options);
        }

        public void RegisterNewOperations(IReadOnlyList<VTOperation> newOperations)
        {
            foreach (var newOperation in newOperations)
            {
                switch (newOperation.Stage)
                {
                    case OperationStage.Colmap:
                    case OperationStage.Train:
                    case OperationStage.Render:
                        _operationHub.RegisterNewOperation(newOperation);
                        break;
                    case OperationStage.Waiting:
                    case OperationStage.PrepareData:
                    case OperationStage.SavingColmap:
                    case OperationStage.CleanupTrain:
                    case OperationStage.SavingRender:
                    case OperationStage.Finished:
                        _multiOperationHub.RegisterNewOperation(newOperation);
                        break;
                    default:
                        break;
                }
            }
        }

        public void RunNext(OperationStage stage)
        {
            switch (stage)
            {
                case OperationStage.Colmap:
                case OperationStage.Train:
                case OperationStage.Render:
                    _operationHub.RunNext();
                    break;
                case OperationStage.Waiting:
                case OperationStage.PrepareData:
                case OperationStage.SavingColmap:
                case OperationStage.CleanupTrain:
                case OperationStage.SavingRender:
                case OperationStage.Finished:
                    _multiOperationHub.RunNext();
                    break;
                default:
                    break;
            }
        }
    }
}
