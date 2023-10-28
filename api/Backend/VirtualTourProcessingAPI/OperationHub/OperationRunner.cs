using Microsoft.Extensions.Logging;
using VirtualTourProcessingServer.Model;
using VirtualTourProcessingServer.OperationExecutors;

namespace VirtualTourProcessingServer.OperationHub
{
    public class OperationRunner : IOperationRunner
    {
        private readonly ILogger<OperationRunner> _logger;
        private readonly ITrainExecutor _trainExecutor;
        private readonly IColmapExecutor _colmapExecutor;
        private readonly IExportExecutor _exportExecutor;

        private Task? _runningTask;
        public event Action? OperationFinished;

        public OperationRunner(ILogger<OperationRunner> logger, ITrainExecutor trainExecutor, 
            IColmapExecutor colmapExecutor, IExportExecutor exportExecutor)
        {
            _logger = logger;
            _trainExecutor = trainExecutor;
            _colmapExecutor = colmapExecutor;
            _exportExecutor = exportExecutor;
        }

        public bool TryRun(VTOperation operation)
        {
            if (_runningTask != null)
                return false;

            switch (operation.Status)
            {
                case OperationStatus.Colmap:
                    _runningTask = RunColmap(operation);
                    break;
                case OperationStatus.Train:
                    _runningTask = RunTrain(operation);
                    break;
                case OperationStatus.Render:
                    _runningTask = RunExport(operation);
                    break;
            }

            return true;
        }

        private void FinishOperation()
        {
            _runningTask = null;
            OperationFinished?.Invoke();
        }

        private async Task RunColmap(VTOperation operation)
        {
            _logger.LogInformation($"Running COLMAP for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var colmapParameters = new ColmapParameters();
            await _colmapExecutor.Process(colmapParameters);

            FinishOperation();
        }

        private async Task RunTrain(VTOperation operation)
        {
            _logger.LogInformation($"Running training for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var trainParameters = new TrainParameters();
            await _trainExecutor.Train(trainParameters);

            FinishOperation();
        }

        private async Task RunExport(VTOperation operation)
        {
            _logger.LogInformation($"Running export for operation: {operation.OperationId}, areaId: {operation.AreaId}");

            var exportParameters = new ExportParameters();
            await _exportExecutor.Export(exportParameters);

            FinishOperation();
        }
    }
}
