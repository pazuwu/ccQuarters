using VirtualTourAPI.DTOModel;

namespace VirtualTourAPI.Requests
{
    public class PutLinkRequest
    {
        public string? Text { get; set; }
        public string? DestinationId { get; set; }
        public GeoPointDTO? Position { get; set; }
        public GeoPointDTO? NextOrientation { get; set; }
    }
}
