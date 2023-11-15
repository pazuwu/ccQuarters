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
    internal class MultiOperationRunner : IMultiOperationRunner
    {
        private readonly ConcurrentDictionary<VTOperation, Task?> _operations = new();
        private readonly ProcessingOptions _options;
        private readonly ILogger _logger;
        private readonly IMediator _mediator;

        private readonly IDownloadExecutor _downloader;
        private readonly IRenderSettingsGenerator _renderSettingsGenerator;
        private readonly IUploadExecutor _uploader;

        public MultiOperationRunner(ILogger<MultiOperationRunner> logger, IOptions<ProcessingOptions> options, IMediator mediator,
            IDownloadExecutor downloader, IRenderSettingsGenerator renderSettingsGenerator, IUploadExecutor uploader)
        {
            if (string.IsNullOrWhiteSpace(options.Value.StorageDirectory))
                throw new Exception("StorageDirectory is empty. Check your configuration file");

            _logger = logger;
            _options = options.Value;
            _mediator = mediator;
            _downloader = downloader;
            _renderSettingsGenerator = renderSettingsGenerator;
            _uploader = uploader;
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
                switch (operation.Stage)
                {
                    case OperationStage.Waiting:
                        _operations[operation] = StartProcessing(operation);
                        break;
                    case OperationStage.PrepareData:
                        _operations[operation] = PrepareData(operation);
                        break;
                    case OperationStage.SavingColmap:
                        _operations[operation] = SaveColmap(operation);
                        break;
                    case OperationStage.CleanupTrain:
                        _operations[operation] = CleanupTrain(operation);
                        break;
                    case OperationStage.PrepareRender:
                        _operations[operation] = PrepareRender(operation);
                        break;
                    case OperationStage.SavingRender:
                        _operations[operation] = SaveRender(operation);
                        break;
                    case OperationStage.Finished:
                        _operations[operation] = CleanAll(operation);
                        break;
                    default:
                        break;
                }
            }

        }

        private async Task StartProcessing(VTOperation operation)
        {
            _logger.LogInformation($"Starting processing operation: {operation.OperationId}, areaId: {operation.AreaId}");
            await FinishOperation(operation, new ExecutorResponse());
        }

        private async Task PrepareData(VTOperation operation)
        {
            _logger.LogInformation($"Downloading data for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var areaLocalDirectory = Path.Combine(_options.StorageDirectory!, operation.TourId, operation.AreaId, "images");
            await _downloader.DownloadPhotos(operation.TourId, operation.AreaId, areaLocalDirectory);

            await FinishOperation(operation, new ExecutorResponse());
        }

        private async Task SaveColmap(VTOperation operation)
        {
            _logger.LogInformation($"Saving COLMAP transforms for operation: {operation.OperationId}, areaId: {operation.AreaId}");
            await FinishOperation(operation, new ExecutorResponse());
        }

        private async Task CleanupTrain(VTOperation operation)
        {
            _logger.LogInformation($"Cleaning trainig for operation: {operation.OperationId}, areaId: {operation.AreaId}");
            await FinishOperation(operation, new ExecutorResponse());
        }

        private async Task PrepareRender(VTOperation operation)
        {
            _logger.LogInformation($"Preparing render settings for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var workingDirectory = Path.Combine(_options.StorageDirectory!, operation.TourId, operation.AreaId);

            var parameters = new GenerateRenderSettingsParameters()
            {
                ColmapTransformsFilePath = Path.Combine(workingDirectory, "transforms.json"),
                OutputFilePath = Path.Combine(workingDirectory, "render_settings.json")
            };

            var response = await _renderSettingsGenerator.GenerateSettings(parameters);
            await FinishOperation(operation, response);
        }

        private async Task SaveRender(VTOperation operation)
        {
            _logger.LogInformation($"Saving renders for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var workingDirectory = Path.Combine(_options.StorageDirectory!, operation.TourId, operation.AreaId);

            var parameters = new UploadExecutorParameters()
            {
                AreaId = operation.AreaId,
                TourId = operation.TourId,
                DirectoryPath = workingDirectory
            };

            var response = await _uploader.SaveScenes(parameters);
            await FinishOperation(operation, response);
        }

        private async Task CleanAll(VTOperation operation)
        {
            _logger.LogInformation($"Cleaning directory after completed operation: {operation.OperationId}, areaId: {operation.AreaId}");
            await FinishOperation(operation, new ExecutorResponse());
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
