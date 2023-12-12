namespace VirtualTourProcessingServer.OperationExecutors.Interfaces
{
    public class RenderParameters
    {
        public required string WorkingDirectory { get; set; }
        public required string CameraConfigPath { get; set; }
        public required string OutputPath { get; set; }
    }

    public interface IRenderExecutor
    {
        Task<ExecutorResponse> Render(RenderParameters parameters);
    }
}
