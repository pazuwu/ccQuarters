using VirtualTourAPI.Client.Model;

namespace VirtualTourAPI.Client.Parameters
{
    public class UpdateOperationParameters
    {
        public required string OperationId { get; set; }
        public OperationStage? Stage { get; set; }
        public OperationStatus? Status { get; set; }
        public int? ProcessingAttempts { get; set; }
    }
}
