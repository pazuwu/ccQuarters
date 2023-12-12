using CCQuartersAPI.CommonClasses;
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

        [TestMethod]
        public async Task UpdateHouseShouldModifyProvidedFieldsAndKeepTheRestUnchanged()
        {
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                var unmodifiedHouseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId, trans);

                Assert.IsNotNull(unmodifiedHouseInfo);

                var updateHouseRequest = new Requests.CreateHouseRequest()
                {
                    Area = 100.5m,
                    Title = "Test modified"
                };

                await _housesService.UpdateHouse(houseId, updateHouseRequest, unmodifiedHouseInfo);

                var modifiedHouseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId, trans);

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
                trans.Rollback();
            }
        }

        [TestMethod]
        public async Task DeleteHouseShouldDeleteHouse()
        {
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                var houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId, trans);

                Assert.IsNotNull(houseInfo);

                await _housesService.DeleteHouse(houseId, trans);

                houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId, trans);

                Assert.IsNull(houseInfo);
            }
            finally
            {
                trans.Rollback();
            }
        }

        [TestMethod]
        public async Task CreateHouseShouldCreateUnlikedHouse()
        {
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                var houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId, trans);

                Assert.IsNotNull(houseInfo);
                Assert.IsFalse(houseInfo.IsLiked);
            }
            finally
            {
                trans.Rollback();
            }
        }

        [TestMethod]
        public async Task LikeHouseShouldLikeHouse()
        {
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                await _housesService.LikeHouse(userId, houseId, trans);

                var houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId, trans);

                Assert.IsNotNull(houseInfo);
                Assert.IsTrue(houseInfo.IsLiked);
            }
            finally
            {
                trans.Rollback();
            }
        }

        [TestMethod]
        public async Task UnlikeHouseShouldUnlikePreviouslyLikedHouse()
        {
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                await _housesService.LikeHouse(userId, houseId, trans);
                await _housesService.UnlikeHouse(userId, houseId, trans);

                var houseInfo = await _housesService.GetDetailedHouseInfo(houseId, userId, trans);

                Assert.IsNotNull(houseInfo);
                Assert.IsFalse(houseInfo.IsLiked);
            }
            finally
            {
                trans.Rollback();
            }
        }

        [TestMethod]
        public async Task LikeHouseShouldOnlyLikeHouseForUserSpecified()
        {
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var createHouseRequest = HousesServiceTestCases.CreateHouses.First();

                var houseId = await _housesService.CreateHouse(userId, createHouseRequest);

                await _housesService.LikeHouse(userId, houseId, trans);

                var houseInfoUserWhoLiked = await _housesService.GetDetailedHouseInfo(houseId, userId, trans);
                var houseInfoUserWhoDidntLike = await _housesService.GetDetailedHouseInfo(houseId, $"{userId}v2", trans);

                Assert.IsNotNull(houseInfoUserWhoLiked);
                Assert.IsNotNull(houseInfoUserWhoDidntLike);
                Assert.IsTrue(houseInfoUserWhoLiked.IsLiked);
                Assert.IsFalse(houseInfoUserWhoDidntLike.IsLiked);
            }
            finally
            {
                trans.Rollback();
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
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var houseIds = new List<Guid?>();
                foreach (var request in HousesServiceTestCases.CreateHouses)
                    houseIds.Add(await _housesService.CreateHouse(userId, request));

                Assert.IsTrue(houseIds.All(id => id is not null));

                var houses = await _housesService.GetSimpleHousesInfo(new GetHousesQuery()
                {
                    SortMethod = sortingMethod
                }, userId, 0, 50, trans);

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
                trans.Rollback();
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
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var houseIds = new List<Guid?>();
                foreach (var request in HousesServiceTestCases.CreateHouses)
                    houseIds.Add(await _housesService.CreateHouse(userId, request));

                Assert.IsTrue(houseIds.All(id => id is not null));

                var houses = await _housesService.GetSimpleHousesInfo(query, userId, 0, 50, trans);

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
                    if (query.OfferTypes is not null && query.OfferTypes.Any())
                        Assert.IsTrue(query.OfferTypes!.Any(type => type == house.OfferType!));
                    if (query.BuildingTypes is not null && query.BuildingTypes.Any())
                        Assert.IsTrue(query.BuildingTypes!.Any(type => type == house.BuildingType!));
                    if (query.Voivodeship is not null)
                        Assert.IsTrue(house.Voivodeship == query.Voivodeship);
                    if (query.Cities is not null && query.Cities.Any())
                        Assert.IsTrue(query.Cities!.Any(city => city == house.City!));
                    if (query.Districts is not null && query.Districts.Any())
                        Assert.IsTrue(query.Districts!.Any(dist => dist == house.District!));
                }
            }
            finally
            {
                trans.Rollback();
            }
        }
    }
}