using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Diagnostics;
using System.Text;

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

            if(string.IsNullOrWhiteSpace(_nsOptions.EnvironmentPath))
                throw new Exception("NerfStudio EnvironmentPath is empty. Check your configuration file.");
        
            string environmentPath = _nsOptions.EnvironmentPath;
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
            if(string.IsNullOrWhiteSpace(parameters.InputDataPath) || string.IsNullOrWhiteSpace(parameters.OutputDirectoryPath))
            {
                return new ExecutorResponse()
                {
                    Status = StatusCode.Error,
                    Message = $"COLMAP processing failed. Wrong parameters: {nameof(parameters.InputDataPath)} and {nameof(parameters.OutputDirectoryPath)} should not be null",
                };
            }

            var nsCommand = "ns-process-data";
            var arguments = $"images --data {parameters.InputDataPath} --output-dir {parameters.OutputDirectoryPath}";

            //var nsProcess = StartExecutorProcess(nsCommand, arguments);
            //ReadAllLogs(nsProcess);
            //await nsProcess.WaitForExitAsync();

            //if (!File.Exists($"{parameters.OutputDirectoryPath}/transforms.json") || nsProcess.ExitCode != 0)
            //{
            //    return new ExecutorResponse()
            //    {
            //        Status = StatusCode.Error,
            //        Message = "COLMAP processing failed. File: transforms.json not found"
            //    };
            //}

            return new ExecutorResponse()
            {
                Status = StatusCode.Ok,
            };
        }

        public async Task<ExecutorResponse> Train(TrainParameters parameters)
        {
            if (string.IsNullOrWhiteSpace(parameters.DataDirectoryPath))
            {
                return new ExecutorResponse()
                {
                    Status = StatusCode.Error,
                    Message = $"COLMAP processing failed. Wrong parameters: {nameof(parameters.DataDirectoryPath)} should not be null",
                };
            }

            var nsCommand = "ns-train";
            var arguments = $"nerfacto --data {parameters.DataDirectoryPath}";
            
            var nsProcess = StartExecutorProcess(nsCommand, arguments);
            ReadAllLogs(nsProcess);
            await nsProcess.WaitForExitAsync();

            if (nsProcess.ExitCode != 0)
                return new ExecutorResponse()
                {
                    Status = StatusCode.Error,
                    Message = $"Training failed. See logs for more information",
                };

            return new ExecutorResponse()
            {
                Status = StatusCode.Ok,
            };
        }

        public async Task<ExecutorResponse> Render(RenderParameters parameters)
        {
            if (string.IsNullOrWhiteSpace(parameters.CameraConfigPath))
            {
                return new ExecutorResponse()
                {
                    Status = StatusCode.Error,
                    Message = $"COLMAP processing failed. Wrong parameters: {nameof(parameters.CameraConfigPath)} should not be null",
                };
            }

            var nsCommand = "ns-render";
            var arguments = $"camera-path --load-config {parameters.CameraConfigPath} --output-path {parameters.OutputPath}";

            var nsProcess = StartExecutorProcess(nsCommand, arguments);
            ReadAllLogs(nsProcess);
            await nsProcess.WaitForExitAsync();

            if (nsProcess.ExitCode != 0)
                return new ExecutorResponse()
                {
                    Status = StatusCode.Error,
                    Message = $"Rendering failed. See logs for more information",
                };

            return new ExecutorResponse()
            {
                Status = StatusCode.Ok,
            };
        }

        private Process StartExecutorProcess(string command, string arguments)
        {
            var startInfo = new ProcessStartInfo(command, arguments)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                StandardOutputEncoding = Encoding.ASCII
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
            while (!process.StandardError.EndOfStream)
            {
                var line = process.StandardError.ReadLine();
                _logger.LogError(line);
            }
            while (!process.StandardOutput.EndOfStream)
            {
                var line = process.StandardOutput.ReadLine();
                _logger.LogDebug(line);
            }
        }
    }
}
