using VirtualTourAPI.Client.Model;

namespace VirtualTourAPI.Client.Parameters
{
    public class UpdateLinkParameters
    {
        public required string TourId { get; set; }
        public required string LinkId { get; set; }
        public string? Text { get; set; }
        public string? DestinationId { get; set; }
        public GeoPointDTO? Position { get; set; }
        public GeoPointDTO? NextOrientation { get; set; }
    }
}
