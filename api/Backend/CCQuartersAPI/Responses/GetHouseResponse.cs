using CCQuartersAPI.CommonClasses;

namespace CCQuartersAPI.Responses
{
    public class GetHouseResponse
    {
        public DetailedHouseDTO House { get; set; }
        public string[]? PhotoUrls { get; set; }
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
        public string UserId { get; set; }
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
        public string? UserName { get; set; }
        public string? UserSurname { get; set; }
        public string? UserCompany {  get; set; }
        public string? UserEmail { get; set; }
        public string? UserPhoneNumber { get; set; }
        public string? UserPhotoUrl { get; set; }
    }
}
