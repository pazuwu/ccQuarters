using CCQuartersAPI.IntegrationTests.Mocks;
using CCQuartersAPI.Services;
using Microsoft.Extensions.Configuration;
using RepositoryLibrary;
using System.Transactions;

namespace CCQuartersAPI.IntegrationTests
{
    [TestClass]
    public class AlertsServiceIntegrationTests
    {
        private const string connectionString = "Server=tcp:ccquartersserver.database.windows.net,1433;Initial Catalog=CCQuartersDB;Persist Security Info=False;User ID=ccq;Password=kotysathebest123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
        private const decimal eps = 1e-3m;

        private readonly IRelationalDBRepository _rdbRepository;
        private readonly IDocumentDBRepository _documentRepository;
        private readonly IAlertsService _alertsService;

        private readonly AsyncLocal<TransactionScope?> _transactionScope = new();

        private readonly string userId = "testUser";

        public AlertsServiceIntegrationTests() 
        {
            var configBuilder = new ConfigurationBuilder();

            _rdbRepository = new RelationalDBRepository(connectionString);
            _documentRepository = new DocumentDBRepositoryMock();
            _alertsService = new AlertsService(configBuilder.Build(), _rdbRepository, _documentRepository);
        }

        [TestMethod]
        public async Task CreateAlertShouldCreateAlert()
        {
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var createAlert = AlertsServiceTestCases.ExampleCreateAlert;

                var id = await _alertsService.CreateAlert(createAlert, userId);

                Assert.IsNotNull(id);

                var getAlert = await _alertsService.GetAlertById(id.Value);

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
                if (_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }

        [TestMethod]
        public async Task UpdateAlertShouldModifyProvidedFieldsAndKeepTheRestUnchanged()
        {
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var createAlert = AlertsServiceTestCases.ExampleCreateAlert;

                var id = await _alertsService.CreateAlert(createAlert, userId);

                Assert.IsNotNull(id);

                var modifyRequest = AlertsServiceTestCases.ExampleUpdateAlert;
                modifyRequest.MaxPrice = 1500000;
                modifyRequest.Cities = new[] { "Gostynin", "Białystok" };
                modifyRequest.Districts = new[] { "Centrum" };

                await _alertsService.UpdateAlert(modifyRequest, id.Value);

                var getAlert = await _alertsService.GetAlertById(id.Value);

                Assert.IsNotNull(getAlert);
                Assert.AreEqual(id, getAlert.Id);
                Assert.AreEqual(createAlert.MinPrice, getAlert.MinPrice);
                Assert.AreEqual(modifyRequest.MaxPrice, getAlert.MaxPrice);
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
                AssertExtensions.AreEqual(modifyRequest.Cities, getAlert.Cities);
                AssertExtensions.AreEqual(modifyRequest.Districts, getAlert.Districts);
            }
            finally
            {
                if (_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }

        [TestMethod]
        public async Task DeleteAlertShouldDeleteAlert()
        {
            _transactionScope.Value = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            try
            {
                var createAlert = AlertsServiceTestCases.ExampleCreateAlert;

                var id = await _alertsService.CreateAlert(createAlert, userId);

                Assert.IsNotNull(id);

                await _alertsService.DeleteAlertById(id.Value);

                var gotAlert = await _alertsService.GetAlertById(id.Value);

                Assert.IsNull(gotAlert);
            }
            finally
            {
                if (_transactionScope.Value != null)
                {
                    _transactionScope.Value.Dispose();
                    _transactionScope.Value = null;
                }
            }
        }
    }
}