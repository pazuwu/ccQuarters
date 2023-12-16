using CCQuartersAPI.CommonClasses;

namespace CCQuartersAPI.Responses
{
    public class GetAlertsResponse : BaseBulkResponse<AlertDTO>
    {
    }

    public class AlertDTO
    {
        public Guid Id { get; set; }
        public string? UserId {  get; set; }
        public decimal? MinPrice { get; set; }
        public decimal? MaxPrice { get; set; }
        public decimal? MinPricePerM2 { get; set; }
        public decimal? MaxPricePerM2 { get; set; }
        public decimal? MaxArea { get; set; }
        public decimal? MinArea { get; set; }
        public int? MaxRoomCount { get; set; }
        public int? MinRoomCount { get; set; }
        public int[]? Floors { get; set; }
        public int? MinFloor { get; set; }
        public int? MaxFloor { get; set; }
        public OfferType? OfferType { get; set; }
        public BuildingType? BuildingType { get; set; }
        public string? Voivodeship { get; set; }
        public string[]? Cities { get; set; }
        public string[]? Districts { get; set; }
    }
}
