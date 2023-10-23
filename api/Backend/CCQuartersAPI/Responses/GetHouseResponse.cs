using CCQuartersAPI.CommonClasses;

namespace CCQuartersAPI.Responses
{
    public class GetHouseResponse
    {
        public DetailedHouseDTO House { get; set; }
        public Guid[]? PhotoIds { get; set; }
    }

    public class DetailedHouseQueried
    {
        public string Title { get; set; }
        public double Price { get; set; }
        public int RoomCount { get; set; }
        public double Area { get; set; }
        public int? Floor { get; set; }
        public Guid DescriptionId { get; set; }
        public Guid AdditionalInfoId { get; set; }
        public Guid? NerfId { get; set; }
        public Guid UserId { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
        public string? District { get; set; }
        public string? StreetName { get; set; }
        public string? StreetNumber { get; set; }
        public string? FlatNumber { get; set; }
        public double? GeoX { get; set; }
        public double? GeoY { get; set; }
        public OfferType OfferType { get; set; }
        public BuildingType BuildingType { get; set; }
        public bool IsLiked { get; set; }
    }

    public class DetailedHouseDTO
    {
        public string Title { get; set; }
        public double Price { get; set; }
        public int RoomCount { get; set; }
        public double Area { get; set; }
        public int? Floor { get; set; }
        public string? Description { get; set; }
        public Dictionary<string, object> Details { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
        public string? District { get; set; }
        public string? StreetName { get; set; }
        public string? StreetNumber { get; set; }
        public string? FlatNumber { get; set; }
        public double? GeoX { get; set; }
        public double? GeoY { get; set; }
        public OfferType OfferType { get; set; }
        public BuildingType BuildingType { get; set; }
        public bool IsLiked { get; set; }
    }

    public class PhotoIdWrapper
    {
        public Guid PhotoId { get; set; }
    }
}
