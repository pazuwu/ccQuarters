using CCQuartersAPI.AlertsDTOs;
using EmailLibrary;
using RepositoryLibrary;
using System.Data;

namespace CCQuartersAPI.Services
{
    public class AlertsService : IAlertsService
    {
        private readonly IConfiguration _configuration;
        private readonly IRelationalDBRepository _rdbRepository;
        private readonly IDocumentDBRepository _documentRepository;

        public AlertsService(IConfiguration configuration, IRelationalDBRepository rdbRepository, IDocumentDBRepository documentRepository)
        {
            _configuration = configuration;
            _rdbRepository = rdbRepository;
            _documentRepository = documentRepository;
        }

        public async Task<AlertDTO[]> GetAlerts(string userId, int pageNumber, int pageSize)
        {
            var query = @$"SELECT * FROM Alerts WHERE UserId = @userId
                           ORDER BY LastUpdateDate DESC
                           OFFSET @pageNumber * @pageSize ROWS
                           FETCH NEXT @pageSize ROWS ONLY";

            var alerts = await _rdbRepository.QueryAsync<AlertDTO>(query, new { userId, pageNumber, pageSize });

            if (alerts is null)
                return Array.Empty<AlertDTO>();

            foreach(var alert in alerts)
                await FillAlertArrayData(alert);

            return alerts.ToArray();
        }

        public async Task<AlertDTO?> GetAlertById(Guid alertId)
        {
            var query = @$"SELECT * FROM Alerts WHERE Id = @alertId";

            var alert = await _rdbRepository.QueryFirstOrDefaultAsync<AlertDTO>(query, new { alertId });

            if (alert is null)
                return null;

            await FillAlertArrayData(alert);
            return alert;
        }

        public async Task<Guid?> CreateAlert(CreateAlertRequest alert, string userId)
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

        public async Task UpdateAlert(UpdateAlertRequest alert, Guid alertId)
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

        public async Task DeleteAlertById(Guid alertId)
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

        public async Task<string[]> GetUserIdsWithAlertsMatchingWithHouse(Guid houseId)
        {
            var userIdsQuery = $@" SELECT DISTINCT UserId FROM Alerts a
                            LEFT JOIN AlertCities ac ON a.Id = ac.AlertId
                            LEFT JOIN AlertDistricts ad ON a.Id = ad.AlertId
                            LEFT JOIN AlertFloors af ON a.Id = af.AlertId
                            WHERE EXISTS 
	                            (
		                            SELECT * FROM Houses h
		                            LEFT JOIN Details d ON h.DetailsId = d.Id
		                            LEFT JOIN Locations l ON h.LocationId = l.Id
		                            WHERE h.Id = @houseId
			                            AND (a.MinPrice IS NULL OR a.MinPrice <= d.Price) AND (a.MaxPrice IS NULL OR a.MaxPrice >= d.Price)
			                            AND (a.MinPricePerM2 IS NULL OR a.MinPricePerM2 <= d.Price / d.Area) AND (a.MaxPricePerM2 IS NULL OR a.MaxPricePerM2 >= d.Price / d.Area)
			                            AND (a.MinArea IS NULL OR a.MinArea <= d.Area) AND (a.MaxArea IS NULL OR a.MaxArea >= d.Area)
			                            AND (a.MinRoomCount IS NULL OR a.MinRoomCount <= d.RoomCount) AND (a.MaxRoomCount IS NULL OR a.MaxRoomCount >= d.RoomCount)
			                            AND (a.MinFloor IS NULL OR a.MinFloor <= d.[Floor]) AND (a.MaxFloor IS NULL OR a.MaxFloor >= d.[Floor]) 
			                            AND (a.OfferType IS NULL OR a.OfferType = h.OfferType) AND (a.BuildingType IS NULL OR a.BuildingType = d.BuildingType)
			                            AND (a.Voivodeship IS NULL OR a.Voivodeship = l.Voivodeship) AND (ac.City IS NULL OR ac.City = l.City)
			                            AND (ad.District IS NULL OR ad.District = l.District) AND (af.[Floor] IS NULL OR af.[Floor] = d.[Floor]) 
	                            )";

            var userIds = await _rdbRepository.QueryAsync<string>(userIdsQuery, new { houseId });

            return userIds?.ToArray() ?? Array.Empty<string>();
        }

        public async Task SendAlertEmails(IEnumerable<string> emails, Guid houseId)
        {
            var emailSender = new AlertEmailSender(_configuration, houseId.ToString());
            var tasks = new List<Task>();
            foreach(var email in emails) 
                tasks.Add(emailSender.Send(email));

            await Task.WhenAll(tasks);
        }

        private async Task FillAlertArrayData(AlertDTO alert)
        {
            Guid alertId = alert.Id;

            var floorsQuery = $@"SELECT Floor FROM AlertFloors WHERE AlertId = @alertId";

            alert.Floors = (await _rdbRepository.QueryAsync<int>(floorsQuery, new { alertId }))?.ToArray();

            var citiesQuery = $@"SELECT City FROM AlertCities WHERE AlertId = @alertId";

            alert.Cities = (await _rdbRepository.QueryAsync<string>(citiesQuery, new { alertId }))?.ToArray();

            var districtsQuery = $@"SELECT District FROM AlertDistricts WHERE AlertId = @alertId";

            alert.Districts = (await _rdbRepository.QueryAsync<string>(districtsQuery, new { alertId }))?.ToArray();
        }

        private async Task InsertAlertAdditonalTables(BaseAlertRequest alert, Guid alertId, IDbTransaction transaction)
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
