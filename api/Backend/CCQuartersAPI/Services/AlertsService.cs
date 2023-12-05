﻿using CCQuartersAPI.Responses;
using CloudStorageLibrary;
using Firebase.Auth;
using RepositoryLibrary;
using System.Data;
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

        public async Task<AlertDTO[]> GetAlerts(string userId, IDbTransaction? trans = null)
        {
            var query = @$"SELECT * FROM Alerts WHERE UserId = @userId";

            var alerts = await _rdbRepository.QueryAsync<AlertDTO>(query, new { userId }, trans);

            return alerts?.ToArray() ?? Array.Empty<AlertDTO>();
        }

        public async Task<AlertDTO?> GetAlertById(Guid alertId, IDbTransaction? trans = null)
        {
            var query = @$"SELECT * FROM Alerts WHERE Id = @alertId";

            return await _rdbRepository.QueryFirstOrDefaultAsync<AlertDTO>(query, new { alertId }, trans);
        }

        public async Task<Guid?> CreateAlert(AlertDTO alert, string userId, IDbTransaction? trans = null)
        {
            string query = $@"INSERT INTO Alerts (Id, UserId, MaxPrice, MaxPricePerM2, MinArea, MaxArea, MinRoomCount, MaxRoomCount, Floor, OfferType, BuildingType, City, ZipCode, District, StreetName, StreetNumber, FlatNumber)
                              OUTPUT INSERTED.Id
                              VALUES (NEWID(), @userId, @maxPrice, @maxPricePerM2, @minArea, @maxArea, @minRoomCount, @maxRoomCount, @floor, @offerType, @buildingType, @city, @zipCode, @district, @streetName, @streetNumber, @flatNumber)";


            return await _rdbRepository.QueryFirstAsync<Guid?>(query, new
            {
                userId,
                maxPrice = alert.MaxPrice,
                maxPricePerM2 = alert.MaxPricePerM2,
                minArea = alert.MinArea,
                maxArea = alert.MaxArea,
                minRoomCount = alert.MinRoomCount,
                maxRoomCount = alert.MaxRoomCount,
                floor = alert.Floor,
                offerType = (int?)alert.OfferType,
                buildingType = (int?)alert.BuildingType,
                city = alert.City,
                zipCode = alert.ZipCode,
                district = alert.District,
                streetName = alert.StreetName,
                streetNumber = alert.StreetNumber,
                flatNumber = alert.FlatNumber
            }, trans);
        } 
        
        public async Task UpdateAlert(AlertDTO alert, Guid alertId, IDbTransaction? trans = null)
        {
            var queryBuilder = new StringBuilder();
            queryBuilder.Append("UPDATE Alerts SET ");

            if (alert.MaxPrice is not null)
                queryBuilder.Append($"MaxPrice = @maxPrice, ");

            if (alert.MaxPricePerM2 is not null)
                queryBuilder.Append($"MaxPricePerM2 = @maxPricePerM2, ");

            if (alert.MinArea is not null)
                queryBuilder.Append($"MinArea = @minArea, ");

            if (alert.MaxArea is not null)
                queryBuilder.Append($"MaxArea = @maxArea, ");

            if (alert.MinRoomCount is not null)
                queryBuilder.Append($"MinRoomCount = @minRoomCount, ");

            if (alert.MaxRoomCount is not null)
                queryBuilder.Append($"MaxRoomCount = @maxRoomCount, ");

            if (alert.Floor is not null)
                queryBuilder.Append($"Floor = @floor, ");

            if (alert.OfferType is not null)
                queryBuilder.Append($"OfferType = @offerType, ");

            if (alert.BuildingType is not null)
                queryBuilder.Append($"BuildingType = @buildingType, ");

            if (alert.City is not null)
                queryBuilder.Append($"City = @city', ");

            if (alert.ZipCode is not null)
                queryBuilder.Append($"ZipCode = @zipCode, ");

            if (alert.District is not null)
                queryBuilder.Append($"District = @district, ");

            if (alert.StreetName is not null)
                queryBuilder.Append($"StreetName = @streetName, ");

            if (alert.StreetNumber is not null)
                queryBuilder.Append($"StreetNumber = @streetNumber, ");

            if (alert.FlatNumber is not null)
                queryBuilder.Append($"FlatNumber = @flatNumber, ");

            var updateQuery = $"{queryBuilder.ToString().TrimEnd(',', ' ')} WHERE Id = @alertId";

            await _rdbRepository.ExecuteAsync(updateQuery, new
            {
                maxPrice = alert.MaxPrice,
                maxPricePerM2 = alert.MaxPricePerM2,
                minArea = alert.MinArea,
                maxArea = alert.MaxArea,
                minRoomCount = alert.MinRoomCount,
                maxRoomCount = alert.MaxRoomCount,
                floor = alert.Floor,
                offerType = (int?)alert.OfferType,
                buildingType = (int?)alert.BuildingType, 
                city = alert.City,
                zipCode = alert.ZipCode,
                district = alert.District,
                streetName = alert.StreetName,
                streetNumber = alert.StreetNumber,
                flatNumber = alert.FlatNumber,
                alertId
            }, trans);
        }

        public async Task DeleteAlertById(Guid alertId, IDbTransaction? trans = null)
        {
            var deleteQuery = @$"DELETE FROM Alerts WHERE Id = @alertId";

            await _rdbRepository.ExecuteAsync(deleteQuery, new { alertId }, trans);
        }
    }
}
