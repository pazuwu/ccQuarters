using System.Data.SqlClient;
using Dapper;
using CCQuartersAPI.Responses;
using System.Text;

namespace CCQuartersAPI.Endpoints
{
    public class AlertsEndpoints
    {
        private static string connectionString = "";

        public static void Init(string connectionString)
        {
            AlertsEndpoints.connectionString = connectionString;
        }

        public static async Task<IResult> GetAlerts()
        {
            using var connection = new SqlConnection(connectionString);

#warning TODO: get userId from context
            Guid userId = Guid.Empty;

            var query = @$"SELECT * FROM Alerts WHERE UserId = '{userId}'";

            var alerts = await connection.QueryAsync<AlertDTO>(query);

            return Results.Ok(new GetAlertsResponse
            {
                Alerts = alerts.ToArray()
            });
        }
        public static async Task<IResult> CreateAlert(AlertDTO alert)
        {
            using var connection = new SqlConnection(connectionString);

#warning TODO: get userId from context
            Guid userId = Guid.Empty;

            var queryBuilder = new StringBuilder();

            queryBuilder.Append(@$"INSERT INTO Alerts (Id, UserId, MaxPrice, MaxPricePerM2, MinArea, MaxArea, MinRoomCount, MaxRoomCount, Floor, OfferType, BuildingType, City, ZipCode, District, StreetName, StreetNumber, FlatNumber) VALUES (NEWID(), '{userId}',");

            if (alert.MaxPrice is not null)
                queryBuilder.Append($"{alert.MaxPrice}, ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.MaxPricePerM2 is not null)
                queryBuilder.Append($"{alert.MaxPricePerM2}, ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.MinArea is not null)
                queryBuilder.Append($"{alert.MinArea}, ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.MaxArea is not null)
                queryBuilder.Append($"{alert.MaxArea}, ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.MinRoomCount is not null)
                queryBuilder.Append($"{alert.MinRoomCount}, ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.MaxRoomCount is not null)
                queryBuilder.Append($"{alert.MaxRoomCount}, ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.Floor is not null)
                queryBuilder.Append($"{alert.Floor}, ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.OfferType is not null)
                queryBuilder.Append($"{(int)alert.OfferType}, ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.BuildingType is not null)
                queryBuilder.Append($"{(int)alert.BuildingType}, ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.City is not null)
                queryBuilder.Append($"'{alert.City}', ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.ZipCode is not null)
                queryBuilder.Append($"'{alert.ZipCode}', ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.District is not null)
                queryBuilder.Append($"'{alert.District}', ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.StreetName is not null)
                queryBuilder.Append($"'{alert.StreetName}', ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.StreetNumber is not null)
                queryBuilder.Append($"'{alert.StreetNumber}', ");
            else
                queryBuilder.Append("NULL, ");

            if (alert.FlatNumber is not null)
                queryBuilder.Append($"'{alert.FlatNumber}'");
            else
                queryBuilder.Append("NULL");

            var insertQuery = $"{queryBuilder.ToString().TrimEnd(',', ' ')})";

            await connection.ExecuteAsync(insertQuery);

            return Results.Ok();
        }
        public static async Task<IResult> UpdateAlert(Guid alertId, AlertDTO alert)
        {
            using var connection = new SqlConnection(connectionString);

#warning TODO: get userId from context
            Guid userId = Guid.Empty;

            var query = @$"SELECT * FROM Alerts WHERE Id = '{alertId}'";

            var alertQueried = await connection.QueryFirstAsync<AlertDTO>(query);

            var queryBuilder = new StringBuilder();
            queryBuilder.Append("UPDATE Alerts SET ");


            if (alert.MaxPrice is not null)
                queryBuilder.Append($"MaxPrice = {alert.MaxPrice}, ");

            if (alert.MaxPricePerM2 is not null)
                queryBuilder.Append($"MaxPricePerM2 = {alert.MaxPricePerM2}, ");

            if (alert.MinArea is not null)
                queryBuilder.Append($"MinArea = {alert.MinArea}, ");

            if (alert.MaxArea is not null)
                queryBuilder.Append($"MaxArea = {alert.MaxArea}, ");

            if (alert.MinRoomCount is not null)
                queryBuilder.Append($"MinRoomCount = {alert.MinRoomCount}, ");

            if (alert.MaxRoomCount is not null)
                queryBuilder.Append($"MaxRoomCount = {alert.MaxRoomCount}, ");

            if (alert.Floor is not null)
                queryBuilder.Append($"Floor = {alert.Floor}, ");

            if (alert.OfferType is not null)
                queryBuilder.Append($"OfferType = {(int)alert.OfferType}, ");

            if (alert.BuildingType is not null)
                queryBuilder.Append($"BuildingType = {(int)alert.BuildingType}, ");

            if (alert.City is not null)
                queryBuilder.Append($"City = '{alert.City}', ");

            if (alert.ZipCode is not null)
                queryBuilder.Append($"ZipCode = '{alert.ZipCode}', ");

            if (alert.District is not null)
                queryBuilder.Append($"District = '{alert.District}', ");

            if (alert.StreetName is not null)
                queryBuilder.Append($"StreetName = '{alert.StreetName}', ");

            if (alert.StreetNumber is not null)
                queryBuilder.Append($"StreetNumber = '{alert.StreetNumber}', ");

            if (alert.FlatNumber is not null)
                queryBuilder.Append($"FlatNumber = '{alert.FlatNumber}', ");

            var updateQuery = $"{queryBuilder.ToString().TrimEnd(',', ' ')} WHERE Id = '{alertId}'";

            await connection.ExecuteAsync(updateQuery);

            return Results.Ok();
        }
        public static async Task<IResult> DeleteAlert(Guid alertId)
        {
            using var connection = new SqlConnection(connectionString);

#warning TODO: get userId from context
            Guid userId = Guid.Empty;

            var query = @$"DELETE FROM Alerts WHERE Id = '{alertId}'";

            await connection.ExecuteAsync(query);

            return Results.Ok();
        }
    }
}
