using Microsoft.Extensions.Logging;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class CleanExecutor : ICleanExecutor
    {
        private readonly ILogger _logger;

        public CleanExecutor(ILogger<CleanExecutor> logger)
        {
            _logger = logger;
        }

        public Task<ExecutorResponse> CleanWorkingDirectory(string path)
        {
            try
            {
                Directory.Delete(path, true);
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
