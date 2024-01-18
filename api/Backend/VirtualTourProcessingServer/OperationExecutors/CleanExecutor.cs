using Microsoft.Extensions.Logging;
using VirtualTourAPI.Client;
using VirtualTourAPI.Client.Parameters;
using VirtualTourProcessingServer.OperationExecutors.Interfaces;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class CleanExecutor : IOperationExecutor
    {
        private readonly ILogger _logger;
        private readonly VTClient _client;

        public CleanExecutor(ILogger<CleanExecutor> logger, VTClient client)
        {
            _logger = logger;
            _client = client;
        }

        public async Task<ExecutorResponse> Execute(ExecutorParameters parameters)
        {
            try
            {
                Directory.Delete(parameters.AreaDirectory, true);

                var deleteOperationParameters = new DeleteOperationParameters()
                {
                    OperationId = parameters.Operation.OperationId
                };

                await _client.Service.DeleteOperation(deleteOperationParameters);

                var deleteAreaParameters = new DeleteAreaParameters()
                {
                    TourId = parameters.Operation.TourId,
                    AreaId = parameters.Operation.AreaId,
                };

                await _client.Service.DeleteArea(deleteAreaParameters);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.ToString());
                return ExecutorResponse.Problem("Error while removing working directory");
            }

            return ExecutorResponse.Ok();
        }
    }
}
