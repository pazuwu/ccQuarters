using CCQuartersAPI.Responses;

namespace CCQuartersAPI.Mappers
{
    public static class HouseMapper
    {
        // map DetailedHouseQueried to DetailedHouseDTO
        public static DetailedHouseDTO Map(this DetailedHouseQueried detailedHouseQueried)
        {
            return new DetailedHouseDTO
            {
                Title = detailedHouseQueried.Title,
                Price = detailedHouseQueried.Price,
                RoomCount = detailedHouseQueried.RoomCount,
                Area = detailedHouseQueried.Area,
                Floor = detailedHouseQueried.Floor,
                City = detailedHouseQueried.City,
                ZipCode = detailedHouseQueried.ZipCode,
                District = detailedHouseQueried.District,
                StreetName = detailedHouseQueried.StreetName,
                StreetNumber = detailedHouseQueried.StreetNumber,
                FlatNumber = detailedHouseQueried.FlatNumber,
                GeoX = detailedHouseQueried.GeoX,
                GeoY = detailedHouseQueried.GeoY,
                OfferType = detailedHouseQueried.OfferType,
                BuildingType = detailedHouseQueried.BuildingType,
                IsLiked = detailedHouseQueried.IsLiked
            };
        }
    }
}
