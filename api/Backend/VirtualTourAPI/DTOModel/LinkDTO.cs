
namespace VirtualTourAPI.DTOModel
{
    public class LinkDTO
    {
        public required string Id { get; set; }
        public string? ParentId { get; set; }
        public string? Text { get; set; }
        public string? DestinationId { get; set; }
        public GeoPointDTO? Position { get; set; }
        public GeoPointDTO? NextOrientation { get; set; }
    }
}
