using CCQuartersAPI.CommonClasses;

namespace CCQuartersAPI.Responses
{
    public class GetAlertsResponse
    {
        public required AlertDTO[] Alerts { get; set; }
    }

    public class AlertDTO
    {
        public Guid Id { get; set; }
        public string? UserId {  get; set; }
        public double? MaxPrice { get; set; }
        public double? MaxPricePerM2 { get; set; }
        public decimal? MinArea { get; set; }
        public decimal? MaxArea { get; set; }
        public int? MinRoomCount { get; set; }
        public int? MaxRoomCount { get; set; }
        public int? Floor { get; set; }
        public OfferType? OfferType { get; set; }
        public BuildingType? BuildingType { get; set; }
        public string? City { get; set; }
        public string? ZipCode { get; set; }
        public string? District { get; set; }
        public string? StreetName { get; set; }
        public string? StreetNumber { get; set; }
        public string? FlatNumber { get; set; }
    }
}
