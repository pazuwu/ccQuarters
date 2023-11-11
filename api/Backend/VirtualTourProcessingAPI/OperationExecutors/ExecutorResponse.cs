
namespace VirtualTourProcessingServer.OperationExecutors
{
    public class ExecutorResponse
    {
        public StatusCode Status { get; set; }
        public string? Message { get; set; }

        public static ExecutorResponse Ok() => new()
        {
            Status = StatusCode.Ok,
        };

        public static ExecutorResponse Problem(string message) => new()
        {
            Status = StatusCode.Error,
            Message = message
        };
    }

    public enum StatusCode
    {
        Ok = 0,
        Error,
    }
}
