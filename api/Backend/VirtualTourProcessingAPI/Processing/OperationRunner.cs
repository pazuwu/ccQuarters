using MediatR;
using Microsoft.Extensions.Logging;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.OperationExecutors;

namespace VirtualTourProcessingServer.OperationHub
{
    public class OperationRunner : IOperationRunner
    {
        private readonly IMediator _mediator;
        private readonly ILogger<OperationRunner> _logger;
        private readonly ITrainExecutor _trainExecutor;
        private readonly IColmapExecutor _colmapExecutor;
        private readonly IRenderExecutor _renderExecutor;

        private VTOperation? _runningOperation;
        private Task? _runningTask;

        public OperationRunner(ILogger<OperationRunner> logger, IMediator mediator,
            ITrainExecutor trainExecutor, IColmapExecutor colmapExecutor, IRenderExecutor exportExecutor)
        {
            _mediator = mediator;
            _logger = logger;
            _trainExecutor = trainExecutor;
            _colmapExecutor = colmapExecutor;
            _renderExecutor = exportExecutor;
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

            switch (_runningOperation.Stage)
            {
                case OperationStage.Colmap:
                    _runningTask = RunColmap(_runningOperation);
                    break;
                case OperationStage.Train:
                    _runningTask = RunTrain(_runningOperation);
                    break;
                case OperationStage.Render:
                    _runningTask = RunRender(_runningOperation);
                    break;
            }
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

            _runningOperation = null;
            return _mediator.Publish(new OperationFinishedNotification(operation));
        }

        private async Task RunColmap(VTOperation operation)
        {
            _logger.LogInformation($"Running COLMAP for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var colmapParameters = new ColmapParameters();
            var response = await _colmapExecutor.Process(colmapParameters);

            _logger.LogInformation($"COLMAP has been finished for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            await FinishOperation(operation, response);
        }

        private async Task RunTrain(VTOperation operation)
        {
            _logger.LogInformation($"Running training for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var trainParameters = new TrainParameters();
            var response = await _trainExecutor.Train(trainParameters);

            _logger.LogInformation($"Training has been finished for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            await FinishOperation(operation, response);
        }

        private async Task RunRender(VTOperation operation)
        {
            _logger.LogInformation($"Running render for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var renderParameters = new RenderParameters();
            var response = await _renderExecutor.Render(renderParameters);

            _logger.LogInformation($"Render has been finished for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            await FinishOperation(operation, response);
        }
    }
}
