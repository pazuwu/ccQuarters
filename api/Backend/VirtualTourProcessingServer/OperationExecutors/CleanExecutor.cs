using Microsoft.Extensions.Logging;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class CleanExecutor : IOperationExecutor
    {
        private readonly ILogger _logger;

        public CleanExecutor(ILogger<CleanExecutor> logger)
        {
            _logger = logger;
        }

        public Task<ExecutorResponse> Execute(ExecutorParameters parameters)
        {
            try
            {
                Directory.Delete(parameters.AreaDirectory, true);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.ToString());
                return Task.FromResult(ExecutorResponse.Problem("Error while removing working directory"));
            }

            return Task.FromResult(ExecutorResponse.Ok());
        }
    }
}
