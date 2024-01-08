﻿using Microsoft.Extensions.Logging;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    internal class RenderExecutor : IOperationExecutor
    {
        private readonly ILogger<RenderExecutor> _logger;
        private readonly IProcessRunner _processRunner;

        public RenderExecutor(ILogger<RenderExecutor> logger, IProcessRunner processRunner)
        {
            _logger = logger;
            _processRunner = processRunner;
        }

        public async Task<ExecutorResponse> Execute(ExecutorParameters parameters)
        {
            var cameraConfigPath = Path.Combine(parameters.AreaDirectory, "render_settings.json");
            var outputPath = Path.Combine(parameters.AreaDirectory, "renders");

            var nerfactoDirectory = Path.Combine(parameters.AreaDirectory, "nerfacto");
            var configDirectory = Directory.GetDirectories(nerfactoDirectory).FirstOrDefault();

            if (configDirectory == null)
                return ExecutorResponse.Problem("Training directory not found");

            var configPath = Path.Combine(configDirectory!, "config.yml");

            var nsCommand = "ns-render";
            var arguments = $"camera-path --load-config {configPath} --camera-path-filename {cameraConfigPath} --output-format images --image-format png --output-path {outputPath}";

            var nsProcess = _processRunner.Start(nsCommand, arguments);
            _processRunner.ReadAllLogs(nsProcess, _logger);
            await nsProcess.WaitForExitAsync();

            if (nsProcess.ExitCode != 0)
                return ExecutorResponse.Problem($"Rendering failed. See logs for more information");

            return ExecutorResponse.Ok();
        }
    }
}
