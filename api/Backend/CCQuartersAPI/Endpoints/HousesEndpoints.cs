using System.Data.SqlClient;
using System.Security.Claims;
using System.Text;
using AuthLibrary;
using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.Mappers;
using CCQuartersAPI.Requests;
using CCQuartersAPI.Responses;
using CloudStorageLibrary;
using Dapper;
using Google.Cloud.Firestore;
using Microsoft.AspNetCore.Mvc;

namespace CCQuartersAPI.Endpoints
{
    public class HousesEndpoints
    {
        private static string connectionString = "";
        private const int DEFAULT_PAGE_NUMBER = 0;
        private const int DEFAULT_PAGE_SIZE = 50;

        public static void Init(string connectionString)
        {
            HousesEndpoints.connectionString = connectionString;
        }

        public static async Task<IResult> GetHouses(HttpContext context, [FromServices]IStorage storage, [FromBody]GetHousesBody body, int? pageNumber, int? pageSize)
        {
            int pageNumberValue = pageNumber ?? DEFAULT_PAGE_NUMBER;
            int pageSizeValue = pageSize ?? DEFAULT_PAGE_SIZE;

            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            var queryBuilder = new StringBuilder();

            var query = @$"SELECT h.Id AS Id, Title, Price, RoomCount, Area, [Floor], City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, IIF((SELECT COUNT(*) FROM LikedHouses WHERE HouseId = h.Id AND UserId = '{userId}')>0, 1, 0) AS IsLiked, PhotoId AS PhotoUrl
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        LEFT JOIN HousePhotos p ON p.HouseId = h.Id AND [Order] = 1
                        WHERE h.DeleteDate IS NULL AND ";

            queryBuilder.Append(query);

            queryBuilder.Append(body);

            queryBuilder.AppendLine();
            queryBuilder.Append($@"OFFSET {pageNumberValue * pageSizeValue} ROWS
                                FETCH NEXT {pageSizeValue} ROWS ONLY");

            var houses = await connection.QueryAsync<SimpleHouseDTO>(queryBuilder.ToString());

            foreach (var house in houses)
                if (!string.IsNullOrWhiteSpace(house.PhotoUrl))
                    house.PhotoUrl = await storage.GetDownloadUrl("housePhotos", house.PhotoUrl);

            return Results.Ok(new GetHousesResponse()
            {
                Data = houses.ToArray(),
                PageNumber = pageNumberValue,
                PageSize = pageSizeValue,
            });
        }

        public static async Task<IResult> GetLikedHouses(HttpContext context, IStorage storage, int? pageNumber, int? pageSize)
        {
            int pageNumberValue = pageNumber ?? DEFAULT_PAGE_NUMBER;
            int pageSizeValue = pageSize ?? DEFAULT_PAGE_SIZE;

            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var query = @$"SELECT h.Id AS Id, Title, Price, RoomCount, Area, [Floor], City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, 1 AS IsLiked, PhotoId AS PhotoUrl
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        LEFT JOIN HousePhotos p ON p.HouseId = h.Id AND [Order] = 1
                        WHERE (SELECT COUNT(*) FROM LikedHouses WHERE HouseId = h.Id AND UserId = '{userId}') > 0 AND h.DeleteDate IS NULL
                        ORDER BY h.UpdateDate
                        OFFSET {pageNumberValue * pageSizeValue} ROWS
                        FETCH NEXT {pageSizeValue} ROWS ONLY";

            var houses = await connection.QueryAsync<SimpleHouseDTO>(query);

            foreach (var house in houses)
                if(!string.IsNullOrWhiteSpace(house.PhotoUrl))
                    house.PhotoUrl = await storage.GetDownloadUrl("housePhotos", house.PhotoUrl);

            return Results.Ok(new GetHousesResponse()
            {
                Data = houses.ToArray(),
                PageNumber = pageNumberValue,
                PageSize = pageSizeValue
            });
        }

        public static async Task<IResult> GetMyHouses(HttpContext context, IStorage storage, int? pageNumber, int? pageSize)
        {
            int pageNumberValue = pageNumber ?? DEFAULT_PAGE_NUMBER;
            int pageSizeValue = pageSize ?? DEFAULT_PAGE_SIZE;

            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var query = @$"SELECT h.Id AS Id, Title, Price, RoomCount, Area, [Floor], City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, 1 AS IsLiked, PhotoId AS PhotoUrl
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        LEFT JOIN HousePhotos p ON p.HouseId = h.Id AND [Order] = 1
                        WHERE UserId = '{userId}' AND h.DeleteDate IS NULL
                        ORDER BY h.UpdateDate
                        OFFSET {pageNumberValue * pageSizeValue} ROWS
                        FETCH NEXT {pageSizeValue} ROWS ONLY";

            var houses = await connection.QueryAsync<SimpleHouseDTO>(query);

            foreach (var house in houses)
                if (!string.IsNullOrWhiteSpace(house.PhotoUrl))
                    house.PhotoUrl = await storage.GetDownloadUrl("housePhotos", house.PhotoUrl);

            return Results.Ok(new GetHousesResponse()
            {
                Data = houses.ToArray(),
                PageNumber = pageNumberValue,
                PageSize = pageSizeValue
            });
        }

        public static async Task<IResult> CreateHouse(CreateHouseRequest houseRequest, HttpContext context)
        {
            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

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

                var locationQuery = @$"INSERT INTO Locations (Id, City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, GeoX, GeoY)
                                    OUTPUT INSERTED.Id
                                    VALUES (NEWID(), '{houseRequest.City}', '{houseRequest.Voivodeship}', '{houseRequest.ZipCode}', '{houseRequest.District}', '{houseRequest.StreetName}', '{houseRequest.StreetNumber}', '{houseRequest.FlatNumber}', '{houseRequest.GeoX}', '{houseRequest.GeoY}')";

                var locationId = await connection.QueryFirstAsync<Guid>(locationQuery, transaction: trans);

                var detailsQuery = @$"INSERT INTO Details (Id, DescriptionId, Price, RoomCount, Area, Floor, BuildingType, AdditionalInfoId, NerfId, Title)
                                    OUTPUT INSERTED.Id
                                    VALUES (NEWID(), '{descriptionRef.Id}', {houseRequest.Price}, {houseRequest.RoomCount}, {houseRequest.Area}, {houseRequest.Floor}, {(int)houseRequest.BuildingType!}, '{additionalInfoRef.Id}', NULL, '{houseRequest.Title}')";

                var detailsId = await connection.QueryFirstAsync<Guid>(detailsQuery, transaction: trans);

                var houseQuery = @$"INSERT INTO Houses (Id, UserId, LocationId, DetailsId, CreationDate, UpdateDate, OfferType)
                                    OUTPUT INSERTED.Id
                                    VALUES (NEWID(), '{userId}', '{locationId}', '{detailsId}', GETDATE(), GETDATE(), {(int)houseRequest!.OfferType!})";

                var createdHouseId = await connection.QueryFirstAsync<Guid>(houseQuery, transaction: trans);

                trans.Commit();

                return Results.Created(createdHouseId.ToString(), null);
            }
            finally
            {
                connection.Close();
            }
        }
        public static async Task<IResult> GetHouse(Guid houseId, HttpContext context, IStorage storage)
        {
            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            var houseQuery = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, IIF((SELECT COUNT(*) FROM LikedHouses WHERE HouseId = h.Id AND UserId = '{userId}')>0, 1, 0) AS IsLiked, DescriptionId, AdditionalInfoId, NerfId, UserId, GeoX, GeoY
                                FROM Houses h
                                JOIN Details d ON h.DetailsId = d.Id
                                JOIN Locations l ON h.LocationId = l.Id
                                WHERE h.Id = '{houseId}' AND h.DeleteDate IS NULL";

            var houseQueried = await connection.QueryFirstAsync<DetailedHouseQueried>(houseQuery);
            var house = houseQueried.Map();

            var photosQuery = @$"SELECT PhotoId AS Filename, [Order] FROM HousePhotos WHERE HouseId = '{houseId}' ORDER BY [Order]";

            var photos = await connection.QueryAsync<PhotoDTO>(photosQuery);

            foreach (var photo in photos)
                photo.Url = await storage.GetDownloadUrl("housePhotos", photo.Filename);

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

            var user = await firestoreDb.GetUser(houseQueried.UserId, storage);

            if(user != null) 
            {
                house.UserName = user.Name;
                house.UserSurname = user.Surname;
                house.UserCompany = user.Company;
                house.UserEmail = user.Email;
                house.UserPhoneNumber = user.PhoneNumber;
            }

            return Results.Ok(new GetHouseResponse()
            {
                House = house,
                Photos = photos.ToArray()
            });
        }

        public static async Task<IResult> UpdateHouse(Guid houseId, CreateHouseRequest houseRequest, HttpContext context)
        {
            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

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
                    return Results.NotFound("House not found");

                if (houseQueried.UserId != userId)
                    return Results.Unauthorized();

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
                                    SET  City = '{houseRequest.City ?? houseQueried.City}', Voivodeship = '{houseRequest.Voivodeship ?? houseQueried.Voivodeship}', ZipCode = '{houseRequest.ZipCode ?? houseQueried.ZipCode}', District = '{houseRequest.District ?? houseQueried.District}', StreetName = '{houseRequest.StreetName ?? houseQueried.StreetName}', StreetNumber = '{houseRequest.StreetNumber ?? houseQueried.StreetNumber}', FlatNumber = '{houseRequest.FlatNumber ?? houseQueried.FlatNumber}', GeoX = {houseRequest.GeoX ?? houseQueried.GeoX}, GeoY = {houseRequest.GeoY ?? houseQueried.GeoY}
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

        public static async Task<IResult> DeleteHouse(Guid houseId, HttpContext context)
        {
            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var getQuery = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, 0 AS IsLiked, DescriptionId, AdditionalInfoId, NerfId, UserId, GeoX, GeoY
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        WHERE h.Id = '{houseId}' AND h.DeleteDate IS NULL";

            var houseQueried = await connection.QueryFirstAsync<DetailedHouseQueried>(getQuery);

            if (houseQueried.UserId != userId)
                return Results.Unauthorized();

            var deleteQuery = @$"UPDATE Houses
                        SET DeleteDate = GETDATE()
                        WHERE Id = '{houseId}'";

            await connection.ExecuteAsync(deleteQuery);

            return Results.Ok();
        }

        public static async Task<IResult> LikeHouse(Guid houseId, HttpContext context)
        {
            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var query = @$"IF NOT EXISTS (SELECT * FROM LikedHouses WHERE HouseId = '{houseId}' AND UserId = '{userId}')
                       BEGIN
                           INSERT INTO LikedHouses 
                           VALUES ('{userId}', '{houseId}')
                       END";

            await connection.ExecuteAsync(query);

            return Results.Ok();
        }

        public static async Task<IResult> UnlikeHouse(Guid houseId, HttpContext context)
        {
            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var query = @$"DELETE FROM LikedHouses WHERE UserId = '{userId}' AND HouseId = '{houseId}'";

            await connection.ExecuteAsync(query);

            return Results.Ok();
        }

        public static async Task<IResult> AddPhoto([FromServices]IStorage storage, Guid houseId, IFormFile file, HttpContext context)
        {
            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var getQuery = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, 0 AS IsLiked, DescriptionId, AdditionalInfoId, NerfId, UserId, GeoX, GeoY
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        WHERE h.Id = '{houseId}' AND h.DeleteDate IS NULL";

            var houseQueried = await connection.QueryFirstAsync<DetailedHouseQueried>(getQuery);

            if (houseQueried?.UserId != userId)
                return Results.Unauthorized();

            var selectQuery = $@"SELECT [Order] FROM HousePhotos WHERE HouseId = '{houseId} ORDER BY [Order] DESC'";

            int count = await connection.QueryFirstAsync<int>(selectQuery);

            string filename = $@"{houseId}_{count + 1}";

            var insertQuery = $@"INSERT INTO HousePhotos VALUES ('{houseId}', '{filename}', {count + 1})";

            await connection.ExecuteAsync(insertQuery);

            await storage.UploadFileAsync("housePhotos", file.OpenReadStream(), filename);
            return Results.Ok();
        }

        public static async Task<IResult> DeleteAllPhotos([FromServices] IStorage storage, Guid houseId, HttpContext context)
        {
            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var getQuery = @$"SELECT HouseId, UserId, PhotoId AS Filename, [Order]
                        FROM Houses h
                        LEFT JOIN HousePhotos p ON h.Id = p.HouseId
                        WHERE h.Id = '{houseId}'";

            var housePhotoQueried = await connection.QueryAsync<HousePhotoQueried>(getQuery);

            if (!housePhotoQueried.Any())
                return Results.Ok();

            if (housePhotoQueried.First().UserId != userId)
                return Results.Unauthorized();

            var deleteQuery = $@"DELETE FROM HousePhotos WHERE HouseId = '{houseId}'";

            await connection.ExecuteAsync(deleteQuery);

            foreach (var photo in housePhotoQueried)
                await storage.DeleteFileAsync("housePhotos", photo.Filename);

            return Results.Ok();
        }

        public static async Task<IResult> DeletePhoto([FromServices] IStorage storage, Guid houseId, HttpContext context, string filename)
        {
            using var connection = new SqlConnection(connectionString);

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var getQuery = @$"SELECT HouseId, UserId, PhotoId AS Filename, [Order]
                        FROM Houses h
                        LEFT JOIN HousePhotos p ON h.Id = p.HouseId
                        WHERE h.Id = '{houseId}'";

            var housePhotoQueried = await connection.QueryAsync<HousePhotoQueried>(getQuery);

            if (!housePhotoQueried.Any())
                return Results.Ok();

            if (housePhotoQueried.First().UserId != userId)
                return Results.Unauthorized();

            var deleteQuery = $@"DELETE FROM HousePhotos WHERE PhotoId = '{filename}'";

            await connection.ExecuteAsync(deleteQuery);

            await storage.DeleteFileAsync("housePhotos", filename);

            return Results.Ok();
        }
    }
}
