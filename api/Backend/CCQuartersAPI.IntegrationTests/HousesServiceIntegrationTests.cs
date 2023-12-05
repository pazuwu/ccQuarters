using CCQuartersAPI.IntegrationTests.Mocks;
using CCQuartersAPI.Services;
using CloudStorageLibrary;
using RepositoryLibrary;

namespace CCQuartersAPI.IntegrationTests
{
    [TestClass]
    public class HousesServiceIntegrationTests
    {
        private const string connectionString = "Server=tcp:ccquartersserver.database.windows.net,1433;Initial Catalog=CCQuartersDB;Persist Security Info=False;User ID=ccq;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
        private const decimal eps = 1e-3m;

        private readonly IRelationalDBRepository _rdbRepository;
        private readonly IDocumentDBRepository _documentRepository;
        private readonly IStorage _storage;
        private readonly IHousesService _housesService;

        private readonly string userId = "testUser";

        public HousesServiceIntegrationTests() 
        {
            _rdbRepository = new RelationalDBRepository(connectionString);
            _documentRepository = new DocumentDBRepositoryMock();
            _storage = new StorageMock();
            _housesService = new HousesService(_rdbRepository, _documentRepository, _storage);
        }

        [TestMethod]
        public async Task CreateHouseShouldCreateHouse()
        {
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                var houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId, trans);

                Assert.IsNotNull(houseInfo);
                Assert.IsTrue(Math.Abs(createHouseRequest.Area!.Value - houseInfo.Area) < eps);
                Assert.AreEqual(createHouseRequest.BuildingType, houseInfo.BuildingType);
                Assert.AreEqual(createHouseRequest.City, houseInfo.City);
                Assert.AreEqual(createHouseRequest.District, houseInfo.District);
                Assert.AreEqual(createHouseRequest.FlatNumber, houseInfo.FlatNumber);
                Assert.AreEqual(createHouseRequest.Floor, houseInfo.Floor);
                Assert.IsTrue(Math.Abs(createHouseRequest.GeoX!.Value - houseInfo.GeoX!.Value) < eps);
                Assert.IsTrue(Math.Abs(createHouseRequest.GeoY!.Value - houseInfo.GeoY!.Value) < eps);
                Assert.AreEqual(createHouseRequest.OfferType, houseInfo.OfferType);
                Assert.IsTrue(Math.Abs(createHouseRequest.Price!.Value - houseInfo.Price) < eps);
                Assert.AreEqual(createHouseRequest.RoomCount, houseInfo.RoomCount);
                Assert.AreEqual(createHouseRequest.StreetName, houseInfo.StreetName);
                Assert.AreEqual(createHouseRequest.StreetNumber, houseInfo.StreetNumber);
                Assert.AreEqual(createHouseRequest.Title, houseInfo.Title);
                Assert.AreEqual(createHouseRequest.Voivodeship, houseInfo.Voivodeship);
                Assert.AreEqual(createHouseRequest.ZipCode, houseInfo.ZipCode);
            }
            finally
            {
                trans.Rollback();
            }
        }
    }
}