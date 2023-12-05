using Google.LongRunning;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Diagnostics;
using System.Text;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class NerfStudioExecutor : ITrainExecutor, IColmapExecutor, IRenderExecutor
    {
        ILogger<NerfStudioExecutor> _logger;
        private readonly NerfStudioOptions _nsOptions;

        public NerfStudioExecutor(ILogger<NerfStudioExecutor> logger, IOptions<NerfStudioOptions> nsOptions)
        {
            _logger = logger;
            _nsOptions = nsOptions.Value;

            if(string.IsNullOrWhiteSpace(_nsOptions.EnvironmentDirectory))
                throw new Exception("NerfStudio EnvironmentPath is empty. Check your configuration file.");
        
            string environmentPath = _nsOptions.EnvironmentDirectory;
            string scriptsPath = $@"{environmentPath}\Scripts";
            string libraryPath = $@"{environmentPath}\Library";
            string binPath = $@"{environmentPath}\bin";
            string exeutablePath = @$"{environmentPath}\Library\bin";
            string mingwBinPath = $@"{environmentPath}\Library\mingw-w64\bin";
            string oldPath = Environment.GetEnvironmentVariable("Path")!;
            Environment.SetEnvironmentVariable("PATH", $"{environmentPath};{scriptsPath};{libraryPath};{binPath};{exeutablePath};{mingwBinPath};{oldPath}", EnvironmentVariableTarget.Process);
            Environment.SetEnvironmentVariable("PYTHONUTF8", "1");
        }

        public async Task<ExecutorResponse> Process(ColmapParameters parameters)
        {
            var nsCommand = "ns-process-data";
            var arguments = $"images --data {parameters.InputDataPath} --output-dir {parameters.OutputDirectoryPath}";

            var nsProcess = StartExecutorProcess(nsCommand, arguments);
            ReadAllLogs(nsProcess);
            await nsProcess.WaitForExitAsync();

            if (!File.Exists($"{parameters.OutputDirectoryPath}/transforms.json") || nsProcess.ExitCode != 0)
                return ExecutorResponse.Problem("COLMAP processing failed. File: transforms.json not found");

            return ExecutorResponse.Ok();
        }

        public async Task<ExecutorResponse> Train(TrainParameters parameters)
        {
            var nsCommand = "ns-train";
            var arguments = $"nerfacto --data {parameters.DataDirectoryPath} --viewer.quit-on-train-completion True --output-dir {parameters.OutputDirectoryPath}";

            var nsProcess = StartExecutorProcess(nsCommand, arguments);
            ReadAllLogs(nsProcess);
            await nsProcess.WaitForExitAsync();

            if (nsProcess.ExitCode != 0)
                return ExecutorResponse.Problem($"Training failed. See logs for more information");

            return ExecutorResponse.Ok();
        }

        public async Task<ExecutorResponse> Render(RenderParameters parameters)
        {
            var nerfactoDirectory = Path.Combine(parameters.WorkingDirectory, "nerfacto");
            var configDirectory = Directory.GetDirectories(nerfactoDirectory).FirstOrDefault();

            if (configDirectory == null)
                return ExecutorResponse.Problem("Training directory not found");

            var configPath = Path.Combine(configDirectory!, "config.yml");

            var nsCommand = "ns-render";
            var arguments = $"camera-path --load-config {configPath} --camera-path-filename {parameters.CameraConfigPath} --output-format images --image-format png --output-path {parameters.OutputPath}";

            var nsProcess = StartExecutorProcess(nsCommand, arguments);
            ReadAllLogs(nsProcess);
            await nsProcess.WaitForExitAsync();

            if (nsProcess.ExitCode != 0)
                return ExecutorResponse.Problem($"Rendering failed. See logs for more information");

            return ExecutorResponse.Ok();
        }

        private Process StartExecutorProcess(string command, string arguments)
        {
            var startInfo = new ProcessStartInfo(command, arguments)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
            };

            var process = new Process()
            {
                StartInfo = startInfo,
            };

            process.Start();

            return process;
        }

        private void ReadAllLogs(Process process)
        {
            while (!process.StandardOutput.EndOfStream)
            {
                var line = process.StandardOutput.ReadLine();
                _logger.LogDebug(line);
            }
            while (!process.StandardError.EndOfStream)
            {
                var line = process.StandardError.ReadLine();
                _logger.LogError(line);
            }
        }
    }
}
