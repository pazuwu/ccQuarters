
namespace VirtualTourProcessingServer.OperationExecutors
{
    public class ExportParameters
    {
    }

    public interface IExportExecutor
    {
        Task<ExecutorResponse> Export(ExportParameters parameters);
    }
}
