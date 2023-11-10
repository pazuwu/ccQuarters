
namespace VirtualTourAPI.ServiceClient.Parameters
{
    public class AddPhotoToAreaParameters
    {
        public required string TourId { get; set; }
        public required string AreaId { get; set; }
        public byte[]? PhotoInBytes { get; set; }
        public string? PhotoPath { get; set; }
    }
}
