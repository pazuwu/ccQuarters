using VirtualTourAPI.Client.Model;

namespace VirtualTourAPI.Client.Parameters
{
    public class UpdateOperationParameters
    {
        public required string TourId { get; set; }
        public required string OperationId { get; set; }
        public OperationStage? Stage { get; set; }
    }
}
