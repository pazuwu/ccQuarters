
namespace VirtualTourProcessingServer.OperationExecutors
{
    public class ExecutorResponse
    {
        public StatusCode Status { get; set; }
        public string? Message { get; set; }
    }

    public enum StatusCode
    {
        Ok = 0,
        Error,
    }
}
