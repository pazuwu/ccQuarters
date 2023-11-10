using VirtualTourAPI.ServiceClient.Model;

namespace VirtualTourAPI.Client.Parameters
{
    public class UpdateLinkParameters
    {
        public string? Text { get; set; }
        public string? DestinationId { get; set; }
        public GeoPointDTO? Position { get; set; }
        public GeoPointDTO? NextOrientation { get; set; }
    }
}
