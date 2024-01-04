namespace VirtualTourAPI.DTOModel
{
    public class NewLinkDTO
    {
        public string? Text { get; set; }
        public string? ParentId { get; set; }
        public required string DestinationId { get; set; }
        public required GeoPointDTO Position { get; set; }
        public GeoPointDTO? NextOrientation { get; set; }
    }
}
