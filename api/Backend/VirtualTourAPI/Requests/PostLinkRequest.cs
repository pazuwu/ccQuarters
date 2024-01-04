using VirtualTourAPI.DTOModel;

namespace VirtualTourAPI.Requests
{
    public class PostLinkRequest
    {
        public string? ParentId { get; set; }
        public string? Text { get; set; }
        public required string DestinationId { get; set; }
        public required GeoPointDTO Position { get; set; }
        public GeoPointDTO? NextOrientation { get; set; }
    }
}
