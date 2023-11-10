namespace VirtualTourAPI.ServiceClient.Parameters
{
    public class CreateSceneParameters
    {
        public required string TourId { get; set; }
        public string? ParentId { get; set; }
    }
}
