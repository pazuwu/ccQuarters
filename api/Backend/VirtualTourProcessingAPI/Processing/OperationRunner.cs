using MediatR;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.OperationExecutors;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;
using VirtualTourProcessingServer.Processing.Interfaces;

namespace VirtualTourProcessingServer.Processing
{
    public class OperationRunner : IOperationRunner
    {
        private readonly IMediator _mediator;
        private readonly ILogger<OperationRunner> _logger;
        private readonly ITrainExecutor _trainExecutor;
        private readonly IColmapExecutor _colmapExecutor;
        private readonly IRenderExecutor _renderExecutor;
        private readonly ProcessingOptions _options;

        private VTOperation? _runningOperation;
        private Task? _runningTask;

        public OperationRunner(ILogger<OperationRunner> logger, IMediator mediator, IOptions<ProcessingOptions> options,
            ITrainExecutor trainExecutor, IColmapExecutor colmapExecutor, IRenderExecutor exportExecutor)
        {
            _mediator = mediator;
            _logger = logger;
            _trainExecutor = trainExecutor;
            _colmapExecutor = colmapExecutor;
            _renderExecutor = exportExecutor;
            _options = options.Value;
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
            }

            _runningOperation = null;
            return _mediator.Publish(new OperationFinishedNotification(operation, response.Status));
        }

        private async Task RunColmap(VTOperation operation)
        {
            _logger.LogInformation($"Running COLMAP for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var areaDirectory = Path.Combine(_options.StorageDirectory!, operation.TourId, operation.AreaId);
            var imagesDirectory = Path.Combine(areaDirectory, "images");

            var colmapParameters = new ColmapParameters()
            {
                InputDataPath = imagesDirectory,
                OutputDirectoryPath = areaDirectory,
            };
            var response = await _colmapExecutor.Process(colmapParameters);

            _logger.LogInformation($"COLMAP has been finished for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            await FinishOperation(operation, response);
        }

        private async Task RunTrain(VTOperation operation)
        {
            _logger.LogInformation($"Running training for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var tourDirectory = Path.Combine(_options.StorageDirectory!, operation.TourId);
            var trainParameters = new TrainParameters()
            {
                DataDirectoryPath = Path.Combine(tourDirectory, operation.AreaId),
                OutputDirectoryPath = tourDirectory,
            };
            var response = await _trainExecutor.Train(trainParameters);

            _logger.LogInformation($"Training has been finished for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            await FinishOperation(operation, response);
        }

        private async Task RunRender(VTOperation operation)
        {
            _logger.LogInformation($"Running render for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var workingDirectory = GetWorkingDirectory(operation);
            var nerfactoDirectory = Path.Combine(workingDirectory, "nerfacto");
            var configDirectory = Directory.GetDirectories(nerfactoDirectory).FirstOrDefault();

            if(configDirectory == null)
            await FinishOperation(operation, ExecutorResponse.Problem("Training directory not found"));

            var renderParameters = new RenderParameters()
            {
                CameraConfigPath = Path.Combine(workingDirectory, "render_settings.json"),
                OutputPath = Path.Combine(workingDirectory, "renders"),
                ConfigPath = Path.Combine(configDirectory!, "config.yml")
            };
            var response = await _renderExecutor.Render(renderParameters);

            _logger.LogInformation($"Render has been finished for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            await FinishOperation(operation, response);
        }

        private string GetWorkingDirectory(VTOperation operation)
        {
            return Path.Combine(_options.StorageDirectory!, operation.TourId, operation.AreaId);
        }
    }
}
