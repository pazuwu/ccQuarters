using VirtualTourProcessingServer.Model;

namespace VirtualTourProcessingServer.OperationExecutors
{
    public class ExecutorParameters
    {
        public required VTOperation Operation { get; set; }
        public required string TourDirectory { get; set; }
        public required string AreaDirectory { get; set; }
    }
}
