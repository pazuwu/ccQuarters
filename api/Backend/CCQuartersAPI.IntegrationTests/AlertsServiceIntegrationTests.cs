using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.IntegrationTests.Mocks;
using CCQuartersAPI.Services;
using CloudStorageLibrary;
using RepositoryLibrary;

namespace CCQuartersAPI.IntegrationTests
{
    [TestClass]
    public class AlertsServiceIntegrationTests
    {
        private const string connectionString = "Server=tcp:ccquartersserver.database.windows.net,1433;Initial Catalog=CCQuartersDB;Persist Security Info=False;User ID=ccq;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
        private const decimal eps = 1e-3m;

        private readonly IRelationalDBRepository _rdbRepository;
        private readonly IAlertsService _alertsService;

        private readonly string userId = "testUser";

        public AlertsServiceIntegrationTests() 
        {
            _rdbRepository = new RelationalDBRepository(connectionString);
            _alertsService = new AlertsService(_rdbRepository);
        }

        [TestMethod]
        public async Task CreateAlertShouldCreateAlert()
        {
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var createAlert = AlertsServiceTestCases.ExampleAlert;

                var id = await _alertsService.CreateAlert(createAlert, userId, trans);

                Assert.IsNotNull(id);

                var getAlert = await _alertsService.GetAlertById(id.Value, trans);

                Assert.IsNotNull(getAlert);
                Assert.AreEqual(id, getAlert.Id);
                Assert.AreEqual(createAlert.MinPrice, getAlert.MinPrice);
                Assert.AreEqual(createAlert.MaxPrice, getAlert.MaxPrice);
                Assert.AreEqual(createAlert.MinPricePerM2, getAlert.MinPricePerM2);
                Assert.AreEqual(createAlert.MaxPricePerM2, getAlert.MaxPricePerM2);
                Assert.IsTrue(Math.Abs(createAlert.MinArea!.Value - getAlert.MinArea!.Value) < eps);
                Assert.IsTrue(Math.Abs(createAlert.MaxArea!.Value - getAlert.MaxArea!.Value) < eps);
                Assert.AreEqual(createAlert.MinRoomCount, getAlert.MinRoomCount);
                Assert.AreEqual(createAlert.MaxRoomCount, getAlert.MaxRoomCount);
                Assert.AreEqual(createAlert.MinFloor, getAlert.MinFloor);
                Assert.AreEqual(createAlert.MaxFloor, getAlert.MaxFloor);
                AssertExtensions.AreEqual(createAlert.Floors, getAlert.Floors);
                Assert.AreEqual(createAlert.OfferType, getAlert.OfferType);
                Assert.AreEqual(createAlert.BuildingType, getAlert.BuildingType);
                Assert.AreEqual(createAlert.Voivodeship, getAlert.Voivodeship);
                AssertExtensions.AreEqual(createAlert.Cities, getAlert.Cities);
                AssertExtensions.AreEqual(createAlert.Districts, getAlert.Districts);
            }
            finally
            {
                trans.Rollback();
            }
        }

        [TestMethod]
        public async Task UpdateAlertShouldModifyProvidedFieldsAndKeepTheRestUnchanged()
        {
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var createAlert = AlertsServiceTestCases.ExampleAlert;

                var id = await _alertsService.CreateAlert(createAlert, userId, trans);

                Assert.IsNotNull(id);

                var modifyRequest = AlertsServiceTestCases.ExampleAlert;
                modifyRequest.MaxPrice = 1500000;
                modifyRequest.Cities = new[] { "Gostynin", "Białystok" };
                modifyRequest.Districts = new[] { "Centrum" };

                await _alertsService.UpdateAlert(modifyRequest, id.Value, trans);

                var getAlert = await _alertsService.GetAlertById(id.Value, trans);

                Assert.IsNotNull(getAlert);
                Assert.AreEqual(id, getAlert.Id);
                Assert.AreEqual(createAlert.MinPrice, getAlert.MinPrice);
                Assert.AreEqual(createAlert.MaxPrice, modifyRequest.MaxPrice);
                Assert.AreEqual(createAlert.MinPricePerM2, getAlert.MinPricePerM2);
                Assert.AreEqual(createAlert.MaxPricePerM2, getAlert.MaxPricePerM2);
                Assert.IsTrue(Math.Abs(createAlert.MinArea!.Value - getAlert.MinArea!.Value) < eps);
                Assert.IsTrue(Math.Abs(createAlert.MaxArea!.Value - getAlert.MaxArea!.Value) < eps);
                Assert.AreEqual(createAlert.MinRoomCount, getAlert.MinRoomCount);
                Assert.AreEqual(createAlert.MaxRoomCount, getAlert.MaxRoomCount);
                Assert.AreEqual(createAlert.MinFloor, getAlert.MinFloor);
                Assert.AreEqual(createAlert.MaxFloor, getAlert.MaxFloor);
                AssertExtensions.AreEqual(createAlert.Floors, getAlert.Floors);
                Assert.AreEqual(createAlert.OfferType, getAlert.OfferType);
                Assert.AreEqual(createAlert.BuildingType, getAlert.BuildingType);
                Assert.AreEqual(createAlert.Voivodeship, getAlert.Voivodeship);
                AssertExtensions.AreEqual(createAlert.Cities, modifyRequest.Cities);
                AssertExtensions.AreEqual(createAlert.Districts, modifyRequest.Districts);
            }
            finally
            {
                trans.Rollback();
            }
        }

        [TestMethod]
        public async Task DeleteAlertShouldDeleteAlert()
        {
            var trans = _rdbRepository.BeginTransaction();
            try
            {
                var createAlert = AlertsServiceTestCases.ExampleAlert;

                var id = await _alertsService.CreateAlert(createAlert, userId, trans);

                Assert.IsNotNull(id);

                await _alertsService.DeleteAlertById(id.Value, trans);

                var gotAlert = await _alertsService.GetAlertById(id.Value, trans);

                Assert.IsNull(gotAlert);
            }
            finally
            {
                trans.Rollback();
            }
        }
    }
}