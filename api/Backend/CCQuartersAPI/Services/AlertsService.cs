using CCQuartersAPI.Responses;
using CloudStorageLibrary;
using Firebase.Auth;
using RepositoryLibrary;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace CCQuartersAPI.Services
{
    public class AlertsService : IAlertsService
    {
        private readonly IRelationalDBRepository _rdbRepository;

        public AlertsService(IRelationalDBRepository rdbRepository)
        {
            _rdbRepository = rdbRepository;
        }

        public async Task<AlertDTO[]> GetAlerts(string userId, int pageNumber, int pageSize, IDbTransaction? trans = null)
        {
            var query = @$"SELECT * FROM Alerts WHERE UserId = @userId
                           ORDER BY LastUpdateDate DESC
                           OFFSET @pageNumber * @pageSize ROWS
                           FETCH NEXT @pageSize ROWS ONLY";

            var alerts = await _rdbRepository.QueryAsync<AlertDTO>(query, new { userId, pageNumber, pageSize }, trans);

            if (alerts is null)
                return Array.Empty<AlertDTO>();

            foreach(var alert in alerts)
                await FillAlertArrayData(alert, trans);

            return alerts.ToArray();
        }

        public async Task<AlertDTO?> GetAlertById(Guid alertId, IDbTransaction? trans = null)
        {
            var query = @$"SELECT * FROM Alerts WHERE Id = @alertId";

            var alert = await _rdbRepository.QueryFirstOrDefaultAsync<AlertDTO>(query, new { alertId }, trans);

            if (alert is null)
                return null;

            await FillAlertArrayData(alert, trans);
            return alert;
        }

        public async Task<Guid?> CreateAlert(AlertDTO alert, string userId, IDbTransaction? trans = null)
        {
            using var transaction = _rdbRepository.BeginTransaction();
            try
            {
                var mainInsertQuery = $@"INSERT INTO Alerts (Id, UserId, MinPrice, MaxPrice, MinPricePerM2, MaxPricePerM2, MinArea, MaxArea, MinRoomCount, MaxRoomCount, MinFloor, MaxFloor, OfferType, BuildingType, Voivodeship, LastUpdateDate)
                                         OUTPUT INSERTED.Id
                                         VALUES (NEWID(), @userId, @minPrice, @maxPrice, @minPricePerM2, @maxPricePerM2, @minArea, @maxArea, @minRoomCount, @maxRoomCount, @minFloor, @maxFloor, @offerType, @buildingType, @voivodeship, GETDATE())";

                var alertId = await _rdbRepository.QueryFirstAsync<Guid?>(mainInsertQuery, new
                {
                    userId,
                    minPrice = alert.MinPrice,
                    maxPrice = alert.MaxPrice,
                    minPricePerM2 = alert.MinPricePerM2,
                    maxPricePerM2 = alert.MaxPricePerM2,
                    minArea = alert.MinArea,
                    maxArea = alert.MaxArea,
                    minRoomCount = alert.MinRoomCount,
                    maxRoomCount = alert.MaxRoomCount,
                    minFloor = alert.MinFloor,
                    maxFloor = alert.MaxFloor,
                    offerType = (int?)alert.OfferType,
                    buildingType = (int?)alert.BuildingType,
                    voivodeship = alert.Voivodeship
                }, transaction)
                    ?? throw new Exception("Cannot insert alert");
                
                await InsertAlertAdditonalTables(alert, alertId, transaction);

                _rdbRepository.CommitTransaction(transaction);
                return alertId;
            }
            catch
            {
                _rdbRepository.RollbackTransaction(transaction);
                return null;
            }
        }

        public async Task UpdateAlert(AlertDTO alert, Guid alertId, IDbTransaction? trans = null)
        {
            using var transaction = _rdbRepository.BeginTransaction();
            try
            {
                string mainUpdateQuery = $@"UPDATE Alerts
                                        SET MinPrice = @minPrice, MaxPrice = @maxPrice, MinPricePerM2 = @minPricePerM2, MaxPricePerM2 = @maxPricePerM2, MinArea = @minArea, MaxArea = @maxArea, MinRoomCount = @minRoomCount, MaxRoomCount = @maxRoomCount, MinFloor = @minFloor, MaxFloor = @maxFloor, OfferType = @offerType, BuildingType = @buildingType, Voivodeship = @voivodeship, LastUpdateDate = GETDATE()
                                        WHERE Id = @alertId";

                await _rdbRepository.ExecuteAsync(mainUpdateQuery, new
                {
                    minPrice = alert.MinPrice,
                    maxPrice = alert.MaxPrice,
                    minPricePerM2 = alert.MinPricePerM2,
                    maxPricePerM2 = alert.MaxPricePerM2,
                    minArea = alert.MinArea,
                    maxArea = alert.MaxArea,
                    minRoomCount = alert.MinRoomCount,
                    maxRoomCount = alert.MaxRoomCount,
                    minFloor = alert.MinFloor,
                    maxFloor = alert.MaxFloor,
                    offerType = (int?)alert.OfferType,
                    buildingType = (int?)alert.BuildingType,
                    voivodeship = alert.Voivodeship,
                    alertId
                }, transaction);

                await ClearAlertAdditionalTables(alertId, transaction);

                await InsertAlertAdditonalTables(alert, alertId, transaction);

                _rdbRepository.CommitTransaction(transaction);
            }
            catch
            {
                _rdbRepository.RollbackTransaction(transaction);
            }
        }

        public async Task DeleteAlertById(Guid alertId, IDbTransaction? trans = null)
        {
            using var transaction = _rdbRepository.BeginTransaction();
            try
            {
                var deleteQuery = @$"DELETE FROM Alerts WHERE Id = @alertId";

                await ClearAlertAdditionalTables(alertId, transaction);

                await _rdbRepository.ExecuteAsync(deleteQuery, new { alertId }, transaction);

                _rdbRepository.CommitTransaction(transaction);
            }
            catch
            {
                _rdbRepository.RollbackTransaction(transaction);
                throw;
            }
        }

        private async Task FillAlertArrayData(AlertDTO alert, IDbTransaction? trans)
        {
            Guid alertId = alert.Id;

            var floorsQuery = $@"SELECT Floor FROM AlertFloors WHERE AlertId = @alertId";

            alert.Floors = (await _rdbRepository.QueryAsync<int>(floorsQuery, new { alertId }, trans))?.ToArray();

            var citiesQuery = $@"SELECT City FROM AlertCities WHERE AlertId = @alertId";

            alert.Cities = (await _rdbRepository.QueryAsync<string>(citiesQuery, new { alertId }, trans))?.ToArray();

            var districtsQuery = $@"SELECT District FROM AlertDistricts WHERE AlertId = @alertId";

            alert.Districts = (await _rdbRepository.QueryAsync<string>(districtsQuery, new { alertId }, trans))?.ToArray();
        }

        private async Task InsertAlertAdditonalTables(AlertDTO alert, Guid alertId, IDbTransaction transaction)
        {
            if (alert.Floors is not null && alert.Floors.Any())
            {
                var floorsInsertQuery = $@"INSERT INTO AlertFloors (AlertId, Floor)
                                           VALUES (@alertId, @floor)";

                await _rdbRepository.ExecuteAsync(floorsInsertQuery, alert.Floors.Select(floor => new { alertId, floor })/*new { alertId, floors = alert.Floors }*/, transaction);
            }

            if (alert.Cities is not null && alert.Cities.Any())
            {
                var citiesInsertQuery = $@"INSERT INTO AlertCities (AlertId, City)
                                           VALUES (@alertId, @city)";

                await _rdbRepository.ExecuteAsync(citiesInsertQuery, alert.Cities.Select(city => new { alertId, city })/* new { alertId, cities = alert.Cities }*/, transaction);
            }

            if (alert.Districts is not null && alert.Districts.Any())
            {
                var districtsInsertQuery = $@"INSERT INTO AlertDistricts (AlertId, District)
                                              VALUES (@alertId, @district)";

                await _rdbRepository.ExecuteAsync(districtsInsertQuery, alert.Districts.Select(district => new { alertId, district })/*new { alertId, districts = alert.Districts }*/, transaction);
            }
        }

        private async Task ClearAlertAdditionalTables(Guid alertId, IDbTransaction transaction)
        {
            var floorsDeleteQuery = @$"DELETE FROM AlertFloors WHERE AlertId = @alertId";

            await _rdbRepository.ExecuteAsync(floorsDeleteQuery, new { alertId }, transaction);

            var citiesDeleteQuery = @$"DELETE FROM AlertCities WHERE AlertId = @alertId";

            await _rdbRepository.ExecuteAsync(citiesDeleteQuery, new { alertId }, transaction);

            var districtsDeleteQuery = @$"DELETE FROM AlertDistricts WHERE AlertId = @alertId";

            await _rdbRepository.ExecuteAsync(districtsDeleteQuery, new { alertId }, transaction);
        }
    }
}
