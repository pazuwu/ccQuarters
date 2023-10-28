namespace VirtualTourProcessingServer.OperationExecutors
{
    public class ColmapParameters
    {
        public string? WorkingDirectory { get; set; } = @"P:\\python_matrix_scripts";
        public string? InputDataPath { get; set; } = @"P:\python_matrix_scripts\data\inputs\test_server";
        public string? OutputDirectoryPath { get; set; } = @"P:\python_matrix_scripts\data\outputs\server-output";
    }

    public interface IColmapExecutor
    {
        Task<ExecutorResponse> Process(ColmapParameters parameters);
    }
}
