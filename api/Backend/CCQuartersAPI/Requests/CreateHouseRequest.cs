using CCQuartersAPI.CommonClasses;

namespace CCQuartersAPI.Requests
{
    public class CreateHouseRequest
    {
        public string? Title { get; set; }
        public decimal? Price { get; set; }
        public int? RoomCount { get; set; }
        public decimal? Area { get; set; }
        public int? Floor { get; set; }
        public string? Description { get; set; }
        public Dictionary<string, string>? AdditionalInfo { get; set; }
        public string? City { get; set; }
        public string? Voivodeship { get; set; }
        public string? ZipCode { get; set; }
        public string? District { get; set; }
        public string? StreetName { get; set; }
        public string? StreetNumber { get; set; }
        public string? FlatNumber { get; set; }
        public decimal? GeoX { get; set; }
        public decimal? GeoY { get; set; }
        public OfferType? OfferType { get; set; }
        public BuildingType? BuildingType { get; set; }
    }
}
