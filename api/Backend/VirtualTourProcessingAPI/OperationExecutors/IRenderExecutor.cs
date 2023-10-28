
namespace VirtualTourProcessingServer.OperationExecutors
{
    public class RenderParameters
    {
        public string? CameraConfigPath { get; set; }
        public string? OutputPath { get; set; }
    }

    public interface IRenderExecutor
    {
        Task<ExecutorResponse> Render(RenderParameters parameters);
    }
}
