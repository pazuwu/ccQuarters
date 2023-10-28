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

            if(_nsOptions.EnvironmentPath is null)
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
            var nsCommand = "ns-process-data";
            var arguments = $"images --data {parameters.InputDataPath} --output-dir {parameters.OutputDirectoryPath}";

            var startInfo = new ProcessStartInfo(nsCommand, arguments)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                StandardOutputEncoding = Encoding.ASCII
            };

            var nsProcess = new Process()
            {
                StartInfo = startInfo,
            };

            nsProcess.Start();
            ReadLogs(nsProcess);
            await nsProcess.WaitForExitAsync();

            if(!File.Exists($"{parameters.OutputDirectoryPath}/transforms.json") || nsProcess.ExitCode != 0)
            {
                _logger.LogError("COLMAP processing failed. File: transforms.json was not created");

                return new ExecutorResponse()
                {
                    Status = StatusCode.Error,
                };
            }

            return new ExecutorResponse()
            {
                Status = StatusCode.Ok,
            };
        }

        public async Task<ExecutorResponse> Train(TrainParameters parameters)
        {
            var nsCommand = "ns-train";
            var arguments = $"nerfacto --data {parameters.DataDirectoryPath}";

            var startInfo = new ProcessStartInfo(nsCommand, arguments)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                StandardOutputEncoding = Encoding.ASCII
            };

            var nsProcess = new Process()
            {
                StartInfo = startInfo,
            };

            nsProcess.Start();
            ReadLogs(nsProcess);
            await nsProcess.WaitForExitAsync();

            if (nsProcess.ExitCode != 0)
                return new ExecutorResponse()
                {
                    Status = StatusCode.Error,
                };

            return new ExecutorResponse()
            {
                Status = StatusCode.Ok,
            };
        }

        private void ReadLogs(Process process)
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

        public Task<ExecutorResponse> Render(RenderParameters parameters)
        {
            throw new NotImplementedException();
        }
    }
}
