namespace VirtualTourProcessingServer.OperationExecutors.Interfaces
{
    public class GenerateRenderSettingsParameters
    {
        public required string OutputFilePath { get; set; }
        public required string ColmapTransformsFilePath { get; set; }
    }

    public interface IRenderSettingsGenerator
    {
        Task<ExecutorResponse> GenerateSettings(GenerateRenderSettingsParameters parameters);
    }
}
