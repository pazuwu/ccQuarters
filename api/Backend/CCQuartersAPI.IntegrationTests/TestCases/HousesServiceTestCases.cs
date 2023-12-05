using CCQuartersAPI.Requests;
using CloudStorageLibrary;
using Google.Cloud.Firestore;
using RepositoryLibrary;

namespace CCQuartersAPI.IntegrationTests.Mocks
{
    internal static class HousesServiceTestCases
    {
        public static CreateHouseRequest[] CreateHouses { get; } = new CreateHouseRequest[]
        {
            new CreateHouseRequest()
                {
                    Area = 50,
                    BuildingType = CommonClasses.BuildingType.House,
                    City = "Warszawa",
                    District = "Mokotów",
                    FlatNumber = "1",
                    Floor = 1,
                    GeoX = 20.5m,
                    GeoY = 30.2m,
                    OfferType = CommonClasses.OfferType.Sale,
                    Price = 1000000,
                    RoomCount = 5,
                    StreetName = "Testowa",
                    StreetNumber = "1",
                    Title = "Test 1",
                    Voivodeship = "Mazowieckie",
                    ZipCode = "02-673"
                },
            new CreateHouseRequest()
                {
                    Area = 100,
                    BuildingType = CommonClasses.BuildingType.Apartment,
                    City = "Warszawa",
                    District = "Bielany",
                    FlatNumber = "300",
                    Floor = 2,
                    GeoX = 25.5m,
                    GeoY = 31.2m,
                    OfferType = CommonClasses.OfferType.Rent,
                    Price = 10000,
                    RoomCount = 3,
                    StreetName = "Testowa",
                    StreetNumber = "2",
                    Title = "Test 2",
                    Voivodeship = "Mazowieckie",
                    ZipCode = "01-853"
                },
            new CreateHouseRequest()
                {
                    Area = 10,
                    BuildingType = CommonClasses.BuildingType.Room,
                    City = "Łódź",
                    FlatNumber = "234",
                    Floor = 5,
                    GeoX = 14.5m,
                    GeoY = 45.2m,
                    OfferType = CommonClasses.OfferType.Rent,
                    Price = 2000,
                    RoomCount = 5,
                    StreetName = "Testowa",
                    StreetNumber = "59",
                    Title = "Test 3",
                    Voivodeship = "Łódzkie",
                    ZipCode = "00-000"
                }
        };
    }
}
