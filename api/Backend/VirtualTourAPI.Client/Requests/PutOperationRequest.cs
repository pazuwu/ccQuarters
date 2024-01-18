using VirtualTourAPI.Client.Model;

namespace VirtualTourAPI.Client.Requests
{
    public class PutOperationRequest
    {
        public OperationStage? Stage { get; set; }
        public OperationStatus? Status { get; set; }
        public int? ProcessingAttempts { get; set; }
    }
}
