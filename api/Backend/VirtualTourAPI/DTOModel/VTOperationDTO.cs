
namespace VirtualTourAPI.DTOModel
{
    public class VTOperationDTO
    {
        public string? AreaId { get; set; }
        public string? TourId { get; set; }
        public int ProcessingAttempts { get; set; }
        public OperationStageDTO Stage { get; set; }
        public OperationStatusDTO Status { get; set; }
    }

    public enum OperationStageDTO
    {
        Waiting,
        Colmap,
        Train,
        PrepareRender,
        Render,
        SavingRender,
        Finished,
    }

    public enum OperationStatusDTO
    {
        Ok,
        Error,
    }
}
