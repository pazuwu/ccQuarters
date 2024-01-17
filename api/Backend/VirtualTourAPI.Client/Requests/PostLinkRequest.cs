using VirtualTourAPI.Client.Model;

namespace VirtualTourAPI.Client.Requests
{
    public class PostLinkRequest
    {
        public string? ParentId { get; set; }
        public string? Text { get; set; }
        public string? DestinationId { get; set; }
        public required GeoPointDTO Position { get; set; }
        public GeoPointDTO? NextOrientation { get; set; }
    }
}
