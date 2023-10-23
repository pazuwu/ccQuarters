using CCQuartersAPI.CommonClasses;

namespace CCQuartersAPI.Responses
{
    public class GetHousesResponse
    {
        public SimpleHouseDTO[] Houses { get; set; }
    }

    public class SimpleHouseDTO
    {
        public string Title { get; set; }
        public double Price { get; set; }
        public int RoomCount { get; set; }
        public double Area { get; set; }
        public int? Floor { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
        public string? District { get; set; }
        public string? StreetName { get; set; }
        public string? StreetNumber { get; set; }
        public string? FlatNumber { get; set; }
        public OfferType OfferType { get; set; }
        public BuildingType BuildingType { get; set; }
        public bool IsLiked { get; set; }
    }
}
