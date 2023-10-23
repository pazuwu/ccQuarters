using System.Data.SqlClient;
using CCQuartersAPI.Mappers;
using CCQuartersAPI.Requests;
using CCQuartersAPI.Responses;
using Dapper;
using Google.Cloud.Firestore;
using Microsoft.AspNetCore.Hosting.Server;

namespace CCQuartersAPI.Endpoints
{
    public class HousesEndpoints
    {
        private static string connectionString = "";

        public static void Init(string connectionString)
        {
            HousesEndpoints.connectionString = connectionString;
        }

        public static async Task<IResult> GetHouses()
        {
            using var connection = new SqlConnection(connectionString);

#warning TODO: Get user id from token
            Guid userId = Guid.Empty;

            var query = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, IIF((SELECT COUNT(*) FROM LikedHouses WHERE HouseId = h.Id AND UserId = '{userId}')>0, 1, 0) AS IsLiked
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        WHERE h.DeleteDate IS NULL";

            var houses = await connection.QueryAsync<SimpleHouseDTO>(query);

            return Results.Ok(new GetHousesResponse()
            {
                Houses = houses.ToArray()
            });
        }

        public static async Task<IResult> GetLikedHouses()
        {
            using var connection = new SqlConnection(connectionString);

#warning TODO: Get user id from token
            Guid userId = Guid.Empty;

            var query = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, 1 AS IsLiked
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        WHERE (SELECT COUNT(*) FROM LikedHouses WHERE HouseId = h.Id AND UserId = '{userId}') > 0 AND h.DeleteDate IS NULL";

            var houses = await connection.QueryAsync<SimpleHouseDTO>(query);

            return Results.Ok(new GetHousesResponse()
            {
                Houses = houses.ToArray()
            });
        }

        public static async Task<IResult> CreateHouse(CreateHouseRequest houseRequest)
        {
            using var connection = new SqlConnection(connectionString);

#warning TODO: Get user id from token
            Guid userId = Guid.Empty;

            connection.Open();
            try
            {
                using var trans = connection.BeginTransaction();
                FirestoreDb firestoreDb = FirestoreDb.Create("ccquartersmini");

                DocumentReference additionalInfoRef = firestoreDb.Collection("additionalInfos").Document(Guid.NewGuid().ToString());
                await additionalInfoRef.SetAsync(houseRequest.AdditionalInfo ?? new Dictionary<string, string>(), SetOptions.MergeAll);

                DocumentReference descriptionRef = firestoreDb.Collection("descriptions").Document(Guid.NewGuid().ToString());
                await descriptionRef.SetAsync(new Dictionary<string, object>()
                    {
                        {"description", houseRequest.Description ?? "" }
                    }, SetOptions.MergeAll);

                var locationQuery = @$"INSERT INTO Locations (Id, City, ZipCode, District, StreetName, StreetNumber, FlatNumber, GeoX, GeoY)
                                    OUTPUT INSERTED.Id
                                    VALUES (NEWID(), '{houseRequest.City}', '{houseRequest.ZipCode}', '{houseRequest.District}', '{houseRequest.StreetName}', '{houseRequest.StreetNumber}', '{houseRequest.FlatNumber}', '{houseRequest.GeoX}', '{houseRequest.GeoY}')";

                var locationId = await connection.QueryFirstAsync<Guid>(locationQuery, transaction: trans);

                var detailsQuery = @$"INSERT INTO Details (Id, DescriptionId, Price, RoomCount, Area, Floor, BuildingType, AdditionalInfoId, NerfId, Title)
                                    OUTPUT INSERTED.Id
                                    VALUES (NEWID(), '{descriptionRef.Id}', {houseRequest.Price}, {houseRequest.RoomCount}, {houseRequest.Area}, {houseRequest.Floor}, {(int)houseRequest.BuildingType!}, '{additionalInfoRef.Id}', NULL, '{houseRequest.Title}')";

                var detailsId = await connection.QueryFirstAsync<Guid>(detailsQuery, transaction: trans);

                var houseQuery = @$"INSERT INTO Houses (Id, UserId, LocationId, DetailsId, CreationDate, UpdateDate, OfferType)
                                    VALUES (NEWID(), '{userId}', '{locationId}', '{detailsId}', GETDATE(), GETDATE(), {(int)houseRequest!.OfferType!})";

                await connection.ExecuteAsync(houseQuery, transaction: trans);

                trans.Commit();
            }
            finally
            {
                connection.Close();
            }

            return Results.Ok();
        }
        public static async Task<IResult> GetHouse(Guid houseId)
        {
            using var connection = new SqlConnection(connectionString);

#warning TODO: Get user id from token
            Guid userId = Guid.Empty;

            var houseQuery = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, IIF((SELECT COUNT(*) FROM LikedHouses WHERE HouseId = h.Id AND UserId = '{userId}')>0, 1, 0) AS IsLiked, DescriptionId, AdditionalInfoId, NerfId, UserId, GeoX, GeoY
                                FROM Houses h
                                JOIN Details d ON h.DetailsId = d.Id
                                JOIN Locations l ON h.LocationId = l.Id
                                WHERE h.Id = '{houseId}' AND h.DeleteDate IS NULL";

            var houseQueried = await connection.QueryFirstAsync<DetailedHouseQueried>(houseQuery);
            var house = houseQueried.Map();

            var photosQuery = @$"SELECT PhotoId FROM HousePhotos WHERE HouseId = '{houseId}'";

            var photoIds = await connection.QueryAsync<PhotoIdWrapper>(photosQuery);

            FirestoreDb firestoreDb = FirestoreDb.Create("ccquartersmini");
            DocumentReference descriptionDoc = firestoreDb.Collection("descriptions").Document($"{houseQueried.DescriptionId}");
            DocumentSnapshot descriptionSnapshot = await descriptionDoc.GetSnapshotAsync();
            if (descriptionSnapshot.Exists)
            {
                Dictionary<string, object> values = descriptionSnapshot.ToDictionary();
                house.Description = values.FirstOrDefault().Value.ToString();
            }

            DocumentReference detailsDoc = firestoreDb.Collection("additionalInfos").Document($"{houseQueried.AdditionalInfoId}");
            DocumentSnapshot detailsSnapshot = await detailsDoc.GetSnapshotAsync();
            if (detailsSnapshot.Exists)
            {
                house.Details = detailsSnapshot.ToDictionary();
            }

#warning TODO: user and photos from firebase

            return Results.Ok(new GetHouseResponse()
            {
                House = house,
                PhotoIds = photoIds?.Select(x => x.PhotoId)?.ToArray()
            });
        }

        public static async Task<IResult> UpdateHouse(Guid houseId, CreateHouseRequest houseRequest)
        {
            using var connection = new SqlConnection(connectionString);

            connection.Open();
            try
            {
                var houseQuery = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, 0 AS IsLiked, DescriptionId, AdditionalInfoId, NerfId, UserId, GeoX, GeoY
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        WHERE h.Id = '{houseId}' AND h.DeleteDate IS NULL";

                var houseQueried = await connection.QueryFirstAsync<DetailedHouseQueried>(houseQuery);

                if (houseQueried is null)
                {
                    return Results.NotFound("House not found");
                }

                using var trans = connection.BeginTransaction();
                FirestoreDb firestoreDb = FirestoreDb.Create("ccquartersmini");

                if (houseRequest.AdditionalInfo is not null)
                {
                    DocumentReference additionalInfoRef = firestoreDb.Collection("additionalInfos").Document(houseQueried.AdditionalInfoId.ToString());
                    await additionalInfoRef.SetAsync(houseRequest.AdditionalInfo, SetOptions.MergeAll);
                }

                if (houseRequest.Description is not null)
                {
                    DocumentReference descriptionRef = firestoreDb.Collection("descriptions").Document(houseQueried.DescriptionId.ToString());
                    await descriptionRef.SetAsync(new Dictionary<string, object>()
                        {
                            {"description", houseRequest.Description ?? "" }
                        }, SetOptions.MergeAll);
                }

                var locationQuery = @$"UPDATE Locations
                                    SET  City = '{houseRequest.City ?? houseQueried.City}', ZipCode = '{houseRequest.ZipCode ?? houseQueried.ZipCode}', District = '{houseRequest.District ?? houseQueried.District}', StreetName = '{houseRequest.StreetName ?? houseQueried.StreetName}', StreetNumber = '{houseRequest.StreetNumber ?? houseQueried.StreetNumber}', FlatNumber = '{houseRequest.FlatNumber ?? houseQueried.FlatNumber}', GeoX = {houseRequest.GeoX ?? houseQueried.GeoX}, GeoY = {houseRequest.GeoY ?? houseQueried.GeoY}
                                    WHERE Id IN (SELECT LocationId FROM Houses WHERE Id = '{houseId}')";

                await connection.ExecuteAsync(locationQuery, transaction: trans);

                var detailsQuery = @$"UPDATE Details
                                    SET Price = {houseRequest.Price ?? houseQueried.Price}, RoomCount = {houseRequest.RoomCount ?? houseQueried.RoomCount}, Area = {houseRequest.Area ?? houseQueried.Area}, Floor = {houseRequest.Floor ?? houseQueried.Floor}, BuildingType = {(int)(houseRequest.BuildingType ?? houseQueried.BuildingType)}, Title = '{houseRequest.Title ?? houseQueried.Title}'
                                    WHERE Id IN (SELECT DetailsId FROM Houses WHERE Id = '{houseId}')";

                await connection.ExecuteAsync(detailsQuery, transaction: trans);

                var houseUpdateQuery = @$"UPDATE Houses 
                                        SET UpdateDate = GETDATE(), OfferType = {(int)(houseRequest.OfferType ?? houseQueried.OfferType)}
                                        WHERE Id = '{houseId}'";

                await connection.ExecuteAsync(houseUpdateQuery, transaction: trans);

                trans.Commit();
            }
            finally
            {
                connection.Close();
            }

            return Results.Ok();
        }

        public static async Task<IResult> DeleteHouse(Guid houseId)
        {
            using var connection = new SqlConnection(connectionString);

#warning TODO: Get user id from token
            Guid userId = Guid.Empty;

            var query = @$"UPDATE Houses
                        SET DeleteDate = GETDATE()
                        WHERE Id = '{houseId}'";

            await connection.ExecuteAsync(query);

            return Results.Ok();
        }

        public static async Task<IResult> LikeHouse(Guid houseId)
        {
            using var connection = new SqlConnection(connectionString);

#warning TODO: Get user id from token
            Guid userId = Guid.Empty;

            var query = @$"IF NOT EXISTS (SELECT * FROM LikedHouses WHERE HouseId = '{houseId}' AND UserId = '{userId}')
                       BEGIN
                           INSERT INTO LikedHouses 
                           VALUES ('{userId}', '{houseId}')
                       END";

            await connection.ExecuteAsync(query);

            return Results.Ok();
        }

        public static async Task<IResult> UnlikeHouse(Guid houseId)
        {
            using var connection = new SqlConnection(connectionString);

#warning TODO: Get user id from token
            Guid userId = Guid.Empty;

            var query = @$"DELETE FROM LikedHouses WHERE UserId = '{userId}' AND HouseId = '{houseId}'";

            await connection.ExecuteAsync(query);

            return Results.Ok();
        }

        public static async Task<IResult> AddPhotos(Guid houseId)
        {
            throw new NotImplementedException();
        }
    }
}
