using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    internal class ColmapExecutor : IOperationExecutor
    {
        private readonly ILogger<ColmapExecutor> _logger;
        private readonly IProcessRunner _processRunner;
        private readonly NerfStudioOptions _options;

        public ColmapExecutor(ILogger<ColmapExecutor> logger, IProcessRunner processRunner, IOptions<NerfStudioOptions> options)
        {
            _logger = logger;
            _processRunner = processRunner;
            _options = options.Value;
        }

        public async Task<ExecutorResponse> Execute(ExecutorParameters parameters)
        {
            var imagesDirectory = Path.Combine(parameters.AreaDirectory, "download");

            var nsCommand = "ns-process-data";
            var arguments = $"images --data {imagesDirectory} --output-dir {parameters.AreaDirectory}";

            var nsProcess = _processRunner.Start(nsCommand, arguments);
            _processRunner.ReadAllLogs(nsProcess, _logger);
            await nsProcess.WaitForExitAsync();

            if (!File.Exists($"{parameters.AreaDirectory}/transforms.json") || nsProcess.ExitCode != 0)
                return ExecutorResponse.Problem("COLMAP processing failed. File: transforms.json not found");

            return ExecutorResponse.Ok();
        }
    }
}
