using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.Requests;
using CCQuartersAPI.Responses;
using CloudStorageLibrary;
using Google.Cloud.Firestore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using RepositoryLibrary;

namespace CCQuartersAPI.IntegrationTests.Mocks
{
    internal static class AlertsServiceTestCases
    {
        public static AlertDTO ExampleAlert { get; } = new()
        {
            MaxPrice = 1000000,
            MaxPricePerM2 = 15000,
            MinArea = 49.5m,
            MaxArea = 60.5m,
            MinRoomCount = 4,
            MaxRoomCount = 6,
            Floor = 3,
            OfferType = OfferType.Sale,
            BuildingType = BuildingType.Apartment,
            City = "Warszawa",
            ZipCode = "02-673",
            District = "Mokotów",
            StreetName = "Testowa",
            StreetNumber = "1",
            FlatNumber = "1"
        };
    }
}
