using CCQuartersAPI.CommonClasses;

namespace CCQuartersAPI.Responses
{
    public class GetHouseResponse
    {
        public DetailedHouseDTO House { get; set; }
        public PhotoDTO[]? Photos { get; set; }
    }

    public class DetailedHouseQueried
    {
        public string Title { get; set; }
        public double Price { get; set; }
        public int RoomCount { get; set; }
        public double Area { get; set; }
        public int? Floor { get; set; }
        public string DescriptionId { get; set; }
        public string AdditionalInfoId { get; set; }
        public string? NerfId { get; set; }
        public string UserId { get; set; }
        public string City { get; set; }
        public string Voivodeship { get; set; }
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
        public string UserId { get; set; }
        public string Title { get; set; }
        public double Price { get; set; }
        public int RoomCount { get; set; }
        public double Area { get; set; }
        public int? Floor { get; set; }
        public string DescriptionId { get; set; }
        public string? Description { get; set; }
        public string AdditionalInfoId { get; set; }
        public Dictionary<string, object>? AdditionalInfo { get; set; }
        public string City { get; set; }
        public string Voivodeship { get; set; }
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

    public class PhotoDTO
    {
        public string Filename { get; set; }
        public string Url { get; set; }
        public int Order { get; set; }
    }
}
