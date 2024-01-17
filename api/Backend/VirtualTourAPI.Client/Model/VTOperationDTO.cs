namespace VirtualTourAPI.Client.Model
{
    public class VTOperationDTO
    {
        public string? AreaId { get; set; }
        public string? TourId { get; set; }
        public int ProcessingAttempts { get; set; }
        public OperationStage Stage { get; set; }
        public OperationStatus Status { get; set; }
    }

    public enum OperationStage
    {
        Waiting,
        Colmap,
        Train,
        PrepareRender,
        Render,
        SavingRender,
        Finished,
    }

    public enum OperationStatus
    {
        Ok,
        Error,
    }
}
