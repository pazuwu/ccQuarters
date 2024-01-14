using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.IntegrationTests.Mocks;
using CCQuartersAPI.Services;
using CloudStorageLibrary;
using RepositoryLibrary;
using System.Transactions;

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

        private readonly AsyncLocal<TransactionScope?> _transactionScope = new();

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
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                var houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId);

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
                if(_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }

        [TestMethod]
        public async Task UpdateHouseShouldModifyProvidedFieldsAndKeepTheRestUnchanged()
        {
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                var unmodifiedHouseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId);

                Assert.IsNotNull(unmodifiedHouseInfo);

                var updateHouseRequest = new Requests.CreateHouseRequest()
                {
                    Area = 100.5m,
                    Title = "Test modified"
                };

                await _housesService.UpdateHouse(houseId, updateHouseRequest, unmodifiedHouseInfo);

                var modifiedHouseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId);

                Assert.IsNotNull(modifiedHouseInfo);

                Assert.IsTrue(Math.Abs(updateHouseRequest.Area!.Value - modifiedHouseInfo.Area) < eps);
                Assert.AreEqual(createHouseRequest.BuildingType, modifiedHouseInfo.BuildingType);
                Assert.AreEqual(createHouseRequest.City, modifiedHouseInfo.City);
                Assert.AreEqual(createHouseRequest.District, modifiedHouseInfo.District);
                Assert.AreEqual(createHouseRequest.FlatNumber, modifiedHouseInfo.FlatNumber);
                Assert.AreEqual(createHouseRequest.Floor, modifiedHouseInfo.Floor);
                Assert.IsTrue(Math.Abs(createHouseRequest.GeoX!.Value - modifiedHouseInfo.GeoX!.Value) < eps);
                Assert.IsTrue(Math.Abs(createHouseRequest.GeoY!.Value - modifiedHouseInfo.GeoY!.Value) < eps);
                Assert.AreEqual(createHouseRequest.OfferType, modifiedHouseInfo.OfferType);
                Assert.IsTrue(Math.Abs(createHouseRequest.Price!.Value - modifiedHouseInfo.Price) < eps);
                Assert.AreEqual(createHouseRequest.RoomCount, modifiedHouseInfo.RoomCount);
                Assert.AreEqual(createHouseRequest.StreetName, modifiedHouseInfo.StreetName);
                Assert.AreEqual(createHouseRequest.StreetNumber, modifiedHouseInfo.StreetNumber);
                Assert.AreEqual(updateHouseRequest.Title, modifiedHouseInfo.Title);
                Assert.AreEqual(createHouseRequest.Voivodeship, modifiedHouseInfo.Voivodeship);
                Assert.AreEqual(createHouseRequest.ZipCode, modifiedHouseInfo.ZipCode);
            }
            finally
            {
                if(_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }

        [TestMethod]
        public async Task DeleteHouseShouldDeleteHouse()
        {
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                var houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId);

                Assert.IsNotNull(houseInfo);

                await _housesService.DeleteHouse(houseId);

                houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId);

                Assert.IsNull(houseInfo);
            }
            finally
            {
                if(_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }

        [TestMethod]
        public async Task CreateHouseShouldCreateUnlikedHouse()
        {
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                var houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId);

                Assert.IsNotNull(houseInfo);
                Assert.IsFalse(houseInfo.IsLiked);
            }
            finally
            {
                if(_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }

        [TestMethod]
        public async Task LikeHouseShouldLikeHouse()
        {
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                await _housesService.LikeHouse(userId, houseId);

                var houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId);

                Assert.IsNotNull(houseInfo);
                Assert.IsTrue(houseInfo.IsLiked);
            }
            finally
            {
                if(_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }

        [TestMethod]
        public async Task UnlikeHouseShouldUnlikePreviouslyLikedHouse()
        {
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                await _housesService.LikeHouse(userId, houseId);
                await _housesService.UnlikeHouse(userId, houseId);

                var houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId);

                Assert.IsNotNull(houseInfo);
                Assert.IsFalse(houseInfo.IsLiked);
            }
            finally
            {
                if(_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }

        [TestMethod]
        public async Task LikeHouseShouldOnlyLikeHouseForUserSpecified()
        {
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                await _housesService.LikeHouse(userId, houseId);

                var houseInfoUserWhoLiked = await _housesService.GetDetailedHouseInfo(houseId, userId);
                var houseInfoUserWhoDidntLike = await _housesService.GetDetailedHouseInfo(houseId, $"{userId}v2");

                Assert.IsNotNull(houseInfoUserWhoLiked);
                Assert.IsNotNull(houseInfoUserWhoDidntLike);
                Assert.IsTrue(houseInfoUserWhoLiked.IsLiked);
                Assert.IsFalse(houseInfoUserWhoDidntLike.IsLiked);
            }
            finally
            {
                if(_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }

        private static IEnumerable<object[]> GetSortingMethods()
        {
            return Enum.GetValues<SortingMethod>().Select(val => new object[] { val });
        }

        [TestMethod]
        [DynamicData(nameof(GetSortingMethods), DynamicDataSourceType.Method)]
        public async Task GetHousesWithSortingMethodShouldSortResults(SortingMethod sortingMethod)
        {
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var houseIds = new List<Guid?>();
                foreach (var request in HousesServiceTestCases.CreateHouses)
                    houseIds.Add(await _housesService.CreateHouse(userId, request));

                Assert.IsTrue(houseIds.All(id => id is not null));

                var houses = await _housesService.GetSimpleHousesInfo(new GetHousesQuery()
                {
                    SortMethod = sortingMethod
                }, userId, 0, 50);

                Assert.IsNotNull(houses);

                var housesArray = houses.ToArray();

                for(int i = 1; i < housesArray.Length; i++)
                {
                    switch (sortingMethod)
                    {
                        case SortingMethod.ByUpdateDateDescending:
                            Assert.IsTrue(housesArray[i - 1].UpdateDate >= housesArray[i].UpdateDate);
                            break;
                        case SortingMethod.ByPriceAscending:
                            Assert.IsTrue(housesArray[i - 1].Price <= housesArray[i].Price);
                            break;
                        case SortingMethod.ByPriceDescending:
                            Assert.IsTrue(housesArray[i - 1].Price >= housesArray[i].Price);
                            break;
                        case SortingMethod.ByPricePerM2Ascending:
                            Assert.IsTrue(housesArray[i - 1].Price / housesArray[i - 1].Area <= housesArray[i].Price / housesArray[i].Area);
                            break;
                        case SortingMethod.ByPricePerM2Descending:
                            Assert.IsTrue(housesArray[i - 1].Price / housesArray[i - 1].Area >= housesArray[i].Price / housesArray[i].Area);
                            break;
                    }
                }
            }
            finally
            {
                if(_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }

        private static IEnumerable<object[]> GetGetHousesQueries()
        {
            return HousesServiceTestCases.GetHousesQueries.Select(val => new object[] { val });
        }

        [TestMethod]
        [DynamicData(nameof(GetGetHousesQueries), DynamicDataSourceType.Method)]
        public async Task GetHousesShouldBeFilteredAccordingToQuery(GetHousesQuery query)
        {
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var houseIds = new List<Guid?>();
                foreach (var request in HousesServiceTestCases.CreateHouses)
                    houseIds.Add(await _housesService.CreateHouse(userId, request));

                Assert.IsTrue(houseIds.All(id => id is not null));

                var houses = await _housesService.GetSimpleHousesInfo(query, userId, 0, 50);

                Assert.IsNotNull(houses);

                foreach(var house in houses)
                {
                    if (query.MinPrice is not null)
                        Assert.IsTrue(house.Price >=  query.MinPrice);
                    if (query.MaxPrice is not null)
                        Assert.IsTrue(house.Price <= query.MaxPrice);
                    if (query.MinPricePerM2 is not null)
                        Assert.IsTrue(house.Price / house.Area >= query.MinPricePerM2);
                    if (query.MaxPricePerM2 is not null)
                        Assert.IsTrue(house.Price / house.Area <= query.MaxPricePerM2);
                    if (query.MaxArea is not null)
                        Assert.IsTrue(house.Area <= query.MaxArea);
                    if (query.MinArea is not null)
                        Assert.IsTrue(house.Area >= query.MinArea);
                    if (query.MaxRoomCount is not null)
                        Assert.IsTrue(house.RoomCount <= query.MaxRoomCount);
                    if (query.MinRoomCount is not null)
                        Assert.IsTrue(house.RoomCount >= query.MinRoomCount);
                    if (query.Floors is not null && query.Floors.Any())
                        Assert.IsTrue(query.Floors!.Any(floor => floor == house.Floor!));
                    if (query.MinFloor is not null)
                        Assert.IsTrue(house.Floor >= query.MinFloor);
                    if (query.MaxFloor is not null)
                        Assert.IsTrue(house.Price <= query.MaxFloor);
                    if (query.OfferType is not null)
                        Assert.IsTrue(query.OfferType == house.OfferType);
                    if (query.BuildingType is not null)
                        Assert.IsTrue(query.BuildingType == house.BuildingType);
                    if (query.Voivodeship is not null)
                        Assert.IsTrue(house.Voivodeship == query.Voivodeship);
                    if (query.Cities is not null && query.Cities.Any())
                        Assert.IsTrue(query.Cities!.Any(city => city.ToLower() == house.City!.ToLower()));
                    if (query.Districts is not null && query.Districts.Any())
                        Assert.IsTrue(query.Districts!.Any(dist => dist.ToLower() == house.District!.ToLower()));
                }
            }
            finally
            {
                if(_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }
    }
}