using Microsoft.Extensions.Logging;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    internal class TrainExecutor : IOperationExecutor
    {
        private readonly ILogger<TrainExecutor> _logger;
        private readonly IProcessRunner _processRunner;

        public TrainExecutor(ILogger<TrainExecutor> logger, IProcessRunner processRunner) 
        {
            _logger = logger;
            _processRunner = processRunner;
        }

        public async Task<ExecutorResponse> Execute(ExecutorParameters parameters)
        {
            var nsCommand = "ns-train";
            var arguments = $"nerfacto --data {parameters.AreaDirectory} --viewer.quit-on-train-completion True --output-dir {parameters.TourDirectory}";

            var nsProcess = _processRunner.Start(nsCommand, arguments);
            _processRunner.ReadAllLogs(nsProcess, _logger);
            await nsProcess.WaitForExitAsync();

            if (nsProcess.ExitCode != 0)
                return ExecutorResponse.Problem($"Training failed. See logs for more information");

            return ExecutorResponse.Ok();
        }
    }
}
