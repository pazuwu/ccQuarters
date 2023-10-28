
namespace VirtualTourProcessingServer.OperationExecutors
{
    public class RenderParameters
    {
    }

    public interface IRenderExecutor
    {
        Task<ExecutorResponse> Render(RenderParameters parameters);
    }
}
