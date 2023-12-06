using VirtualTourAPI.Client.Model;

namespace VirtualTourAPI.Client.Requests
{
    public class PutLinkRequest
    {
        public string? Text { get; set; }
        public string? DestinationId { get; set; }
        public GeoPointDTO? Position { get; set; }
        public GeoPointDTO? NextOrientation { get; set; }
    }
}
