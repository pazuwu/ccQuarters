namespace CCQuartersAPI.CommonClasses
{
    public class GetHousesQuery
    {
        public int? PageSize { get; set; }
        public int? PageNumber { get; set; }
        public SortingMethod? SortMethod { get; set; }
        public double? MinPrice { get; set; }
        public double? MaxPrice { get; set; }
        public double? MinPricePerM2 { get; set; }
        public double? MaxPricePerM2 { get; set; }
        public double? MaxArea { get; set; }
        public double? MinArea { get; set; }
        public int? MaxRoomCount { get; set; }
        public int? MinRoomCount { get; set; }
        public int[]? Floors { get; set; }
        public int? MinFloor { get; set; }
        public int? MaxFloor { get; set; }
        public OfferType[]? OfferTypes { get; set; }
        public BuildingType[]? BuildingTypes { get; set; }
        public string? Voivodeship { get; set; }
        public string[]? Cities { get; set; }
        public string[]? Districts { get; set; }
    }
}
