namespace VirtualTourAPI.DTOModel
{
    public class VTOperationUpdateDTO
    {
        public OperationStageDTO? Stage { get; set; }
        public OperationStatusDTO? Status { get; set; }
        public int? ProcessingAttempts { get; set; }
    }
}