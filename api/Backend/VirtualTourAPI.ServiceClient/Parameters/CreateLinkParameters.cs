using VirtualTourAPI.ServiceClient.Model;

namespace VirtualTourAPI.ServiceClient.Parameters
{
    public class CreateLinkParameters
    {
        public string? ParentId { get; set; }
        public string? Text { get; set; }
        public string? DestinationId { get; set; }
        public double? Longitude { get; set; }
        public double? Latitude { get; set; }
        public GeoPointDTO? NextOrientation { get; set; }
    }
}
