using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.Postprocessing;

namespace VirtualTourProcessingServer.OperationHub
{
    internal class OperationManager : IOperationManager
    {
        private readonly IOperationHub _processingHub;
        private readonly IOperationHub _postprocessingHub;

        public OperationManager(ILogger<OperationManager> logger, IOptions<ProcessingOptions> options, 
            IPostprocessingRunner postprocessingRunner, IOperationRunner operationRunner)
        {
            _processingHub = new OperationHub(logger, operationRunner, options);
            _postprocessingHub = new OperationHub(logger, postprocessingRunner, options);
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
                        _processingHub.RegisterNewOperations(newOperations);
                        break;
                    case OperationStage.SavingColmap:
                    case OperationStage.CleanupTrain:
                    case OperationStage.SavingRender:
                    case OperationStage.Finished:
                        _postprocessingHub.RegisterNewOperations(newOperations);
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
                    _postprocessingHub.RunNext();
                    break;
                case OperationStage.SavingColmap:
                case OperationStage.CleanupTrain:
                case OperationStage.SavingRender:
                case OperationStage.Finished:
                    _processingHub.RunNext();
                    break;
                default:
                    break;
            }
        }
    }
}
