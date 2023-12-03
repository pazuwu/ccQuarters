using System.Security.Claims;
using System.Text;
using AuthLibrary;
using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.Mappers;
using CCQuartersAPI.Requests;
using CCQuartersAPI.Responses;
using CloudStorageLibrary;
using Microsoft.AspNetCore.Mvc;
using RepositoryLibrary;

namespace CCQuartersAPI.Endpoints
{
    public class HousesEndpoints
    {
        private const int DEFAULT_PAGE_NUMBER = 0;
        private const int DEFAULT_PAGE_SIZE = 50;

        public static async Task<IResult> GetHouses(HttpContext context, [FromServices] IRelationalDBRepository relationalRepository, [FromServices]IStorage storage, [FromBody]GetHousesBody body, [FromQuery] int? pageNumber, [FromQuery] int? pageSize)
        {
            int pageNumberValue = pageNumber ?? DEFAULT_PAGE_NUMBER;
            int pageSizeValue = pageSize ?? DEFAULT_PAGE_SIZE;

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

            var houses = await relationalRepository.QueryAsync<SimpleHouseDTO>(queryBuilder.ToString());

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

        public static async Task<IResult> GetLikedHouses(HttpContext context, [FromServices] IRelationalDBRepository repository, IStorage storage, int? pageNumber, int? pageSize)
        {
            int pageNumberValue = pageNumber ?? DEFAULT_PAGE_NUMBER;
            int pageSizeValue = pageSize ?? DEFAULT_PAGE_SIZE;

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

            var houses = await repository.QueryAsync<SimpleHouseDTO>(query);

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

        public static async Task<IResult> GetMyHouses(HttpContext context, [FromServices] IRelationalDBRepository repository, IStorage storage, int? pageNumber, int? pageSize)
        {
            int pageNumberValue = pageNumber ?? DEFAULT_PAGE_NUMBER;
            int pageSizeValue = pageSize ?? DEFAULT_PAGE_SIZE;

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

            var houses = await repository.QueryAsync<SimpleHouseDTO>(query);

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

        public static async Task<IResult> CreateHouse([FromServices] IRelationalDBRepository relationalRepository, [FromServices] IDocumentDBRepository documentRepository, CreateHouseRequest houseRequest, HttpContext context)
        {

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            using var trans = relationalRepository.BeginTransaction();
            try
            {
                string additionalInfoId = await documentRepository.AddAsync("additionalInfos", houseRequest.AdditionalInfo ?? new Dictionary<string, string>());

                string descriptionId = await documentRepository.AddAsync("descriptions", new Dictionary<string, object>()
                    {
                        {"description", houseRequest.Description ?? "" }
                    });

                var locationQuery = @$"INSERT INTO Locations (Id, City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, GeoX, GeoY)
                                    OUTPUT INSERTED.Id
                                    VALUES (NEWID(), '{houseRequest.City}', '{houseRequest.Voivodeship}', '{houseRequest.ZipCode}', '{houseRequest.District}', '{houseRequest.StreetName}', '{houseRequest.StreetNumber}', '{houseRequest.FlatNumber}', '{houseRequest.GeoX}', '{houseRequest.GeoY}')";

                var locationId = await relationalRepository.QueryFirstAsync<Guid>(locationQuery, transaction: trans);

                var detailsQuery = @$"INSERT INTO Details (Id, DescriptionId, Price, RoomCount, Area, Floor, BuildingType, AdditionalInfoId, NerfId, Title)
                                    OUTPUT INSERTED.Id
                                    VALUES (NEWID(), '{descriptionId}', {houseRequest.Price}, {houseRequest.RoomCount}, {houseRequest.Area}, {houseRequest.Floor}, {(int)houseRequest.BuildingType!}, '{additionalInfoId}', NULL, '{houseRequest.Title}')";

                var detailsId = await relationalRepository.QueryFirstAsync<Guid>(detailsQuery, transaction: trans);

                var houseQuery = @$"INSERT INTO Houses (Id, UserId, LocationId, DetailsId, CreationDate, UpdateDate, OfferType)
                                    OUTPUT INSERTED.Id
                                    VALUES (NEWID(), '{userId}', '{locationId}', '{detailsId}', GETDATE(), GETDATE(), {(int)houseRequest!.OfferType!})";

                var createdHouseId = await relationalRepository.QueryFirstAsync<Guid>(houseQuery, transaction: trans);

                relationalRepository.CommitTransaction(transaction: trans);

                return Results.Created(createdHouseId.ToString(), null);
            }
            catch
            {
                relationalRepository.RollbackTransaction(transaction: trans);
                throw;
            }
        }
        public static async Task<IResult> GetHouse([FromServices] IRelationalDBRepository relationaRepository, [FromServices] IDocumentDBRepository documentRepository, Guid houseId, HttpContext context, IStorage storage)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            var houseQuery = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, IIF((SELECT COUNT(*) FROM LikedHouses WHERE HouseId = h.Id AND UserId = '{userId}')>0, 1, 0) AS IsLiked, DescriptionId, AdditionalInfoId, NerfId, UserId, GeoX, GeoY
                                FROM Houses h
                                JOIN Details d ON h.DetailsId = d.Id
                                JOIN Locations l ON h.LocationId = l.Id
                                WHERE h.Id = '{houseId}' AND h.DeleteDate IS NULL";

            var houseQueried = await relationaRepository.QueryFirstOrDefaultAsync<DetailedHouseQueried>(houseQuery);

            if (houseQueried is null)
                return Results.NotFound();

            var house = houseQueried.Map();

            var photosQuery = @$"SELECT PhotoId AS Filename, [Order] FROM HousePhotos WHERE HouseId = '{houseId}' ORDER BY [Order]";

            var photos = await relationaRepository.QueryAsync<PhotoDTO>(photosQuery);

            foreach (var photo in photos)
                photo.Url = await storage.GetDownloadUrl("housePhotos", photo.Filename);

            house.Description = (await documentRepository.GetAsync($"descriptions/{houseQueried.DescriptionId}"))?.ToDictionary().FirstOrDefault().Value?.ToString() ?? string.Empty;

            house.Details = (await documentRepository.GetAsync($"additionalInfos/{houseQueried.AdditionalInfoId}"))?.ToDictionary();

            var user = await documentRepository.GetUser(houseQueried.UserId, storage);

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

        public static async Task<IResult> UpdateHouse([FromServices] IRelationalDBRepository repository, [FromServices] IDocumentDBRepository documentRepository, Guid houseId, CreateHouseRequest houseRequest, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            using var trans = repository.BeginTransaction();
            try
            {
                var houseQuery = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, 0 AS IsLiked, DescriptionId, AdditionalInfoId, NerfId, UserId, GeoX, GeoY
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        WHERE h.Id = '{houseId}' AND h.DeleteDate IS NULL";

                var houseQueried = await repository.QueryFirstAsync<DetailedHouseQueried>(houseQuery, transaction: trans);

                if (houseQueried is null)
                    return Results.NotFound("House not found");

                if (houseQueried.UserId != userId)
                    return Results.Unauthorized();

                if (houseRequest.AdditionalInfo is not null)
                    await documentRepository.SetAsync($"additionalInfo/{houseQueried.AdditionalInfoId}", houseRequest.AdditionalInfo);

                if (houseRequest.Description is not null)
                    await documentRepository.SetAsync($"descriptions/{houseQueried.DescriptionId}", new Dictionary<string, object>()
                        {
                            {"description", houseRequest.Description ?? "" }
                        });

                var locationQuery = @$"UPDATE Locations
                                    SET  City = '{houseRequest.City ?? houseQueried.City}', Voivodeship = '{houseRequest.Voivodeship ?? houseQueried.Voivodeship}', ZipCode = '{houseRequest.ZipCode ?? houseQueried.ZipCode}', District = '{houseRequest.District ?? houseQueried.District}', StreetName = '{houseRequest.StreetName ?? houseQueried.StreetName}', StreetNumber = '{houseRequest.StreetNumber ?? houseQueried.StreetNumber}', FlatNumber = '{houseRequest.FlatNumber ?? houseQueried.FlatNumber}', GeoX = {houseRequest.GeoX ?? houseQueried.GeoX}, GeoY = {houseRequest.GeoY ?? houseQueried.GeoY}
                                    WHERE Id IN (SELECT LocationId FROM Houses WHERE Id = '{houseId}')";

                await repository.ExecuteAsync(locationQuery, transaction: trans);

                var detailsQuery = @$"UPDATE Details
                                    SET Price = {houseRequest.Price ?? houseQueried.Price}, RoomCount = {houseRequest.RoomCount ?? houseQueried.RoomCount}, Area = {houseRequest.Area ?? houseQueried.Area}, Floor = {houseRequest.Floor ?? houseQueried.Floor}, BuildingType = {(int)(houseRequest.BuildingType ?? houseQueried.BuildingType)}, Title = '{houseRequest.Title ?? houseQueried.Title}'
                                    WHERE Id IN (SELECT DetailsId FROM Houses WHERE Id = '{houseId}')";

                await repository.ExecuteAsync(detailsQuery, transaction: trans);

                var houseUpdateQuery = @$"UPDATE Houses 
                                        SET UpdateDate = GETDATE(), OfferType = {(int)(houseRequest.OfferType ?? houseQueried.OfferType)}
                                        WHERE Id = '{houseId}'";

                await repository.ExecuteAsync(houseUpdateQuery, transaction: trans);

                repository.CommitTransaction(transaction: trans);
            }
            catch
            {
                repository.RollbackTransaction(transaction: trans);
                throw;
            }   

            return Results.Ok();
        }

        public static async Task<IResult> DeleteHouse([FromServices] IRelationalDBRepository repository, Guid houseId, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var getQuery = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, 0 AS IsLiked, DescriptionId, AdditionalInfoId, NerfId, UserId, GeoX, GeoY
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        WHERE h.Id = '{houseId}' AND h.DeleteDate IS NULL";

            var houseQueried = await repository.QueryFirstAsync<DetailedHouseQueried>(getQuery);

            if (houseQueried.UserId != userId)
                return Results.Unauthorized();

            var deleteQuery = @$"UPDATE Houses
                        SET DeleteDate = GETDATE()
                        WHERE Id = '{houseId}'";

            await repository.ExecuteAsync(deleteQuery);

            return Results.Ok();
        }

        public static async Task<IResult> LikeHouse([FromServices] IRelationalDBRepository repository, Guid houseId, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var query = @$"IF NOT EXISTS (SELECT * FROM LikedHouses WHERE HouseId = '{houseId}' AND UserId = '{userId}')
                       BEGIN
                           INSERT INTO LikedHouses 
                           VALUES ('{userId}', '{houseId}')
                       END";

            await repository.ExecuteAsync(query);

            return Results.Ok();
        }

        public static async Task<IResult> UnlikeHouse([FromServices] IRelationalDBRepository repository, Guid houseId, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var query = @$"DELETE FROM LikedHouses WHERE UserId = '{userId}' AND HouseId = '{houseId}'";

            await repository.ExecuteAsync(query);

            return Results.Ok();
        }

        public static async Task<IResult> AddPhoto([FromServices] IRelationalDBRepository repository, [FromServices]IStorage storage, Guid houseId, IFormFile file, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var getQuery = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, 0 AS IsLiked, DescriptionId, AdditionalInfoId, NerfId, UserId, GeoX, GeoY
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        WHERE h.Id = '{houseId}' AND h.DeleteDate IS NULL";

            var houseQueried = await repository.QueryFirstAsync<DetailedHouseQueried>(getQuery);

            if (houseQueried?.UserId != userId)
                return Results.Unauthorized();

            var selectQuery = $@"SELECT [Order] FROM HousePhotos WHERE HouseId = '{houseId}' ORDER BY [Order] DESC";

            int count = await repository.QueryFirstOrDefaultAsync<int?>(selectQuery) ?? 0;

            string filename = $@"{houseId}_{count + 1}";

            var insertQuery = $@"INSERT INTO HousePhotos VALUES ('{houseId}', '{filename}', {count + 1})";

            await repository.ExecuteAsync(insertQuery);

            await storage.UploadFileAsync("housePhotos", file.OpenReadStream(), filename);
            return Results.Ok();
        }

        public static async Task<IResult> DeletePhotos([FromServices] IRelationalDBRepository repository, [FromServices] IStorage storage, HttpContext context, [FromBody] DeletePhotosRequest request)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var getQuery = @$"SELECT HouseId, UserId, PhotoId AS Filename, [Order]
                        FROM Houses h
                        LEFT JOIN HousePhotos p ON h.Id = p.HouseId
                        WHERE PhotoId IN @filenames";

            var housePhotoQueried = await repository.QueryAsync<HousePhotoQueried>(getQuery, new { filenames = request.Filenames });

            if (!housePhotoQueried.Any())
                return Results.NotFound();

            if (housePhotoQueried.Any(photo => photo.UserId != userId))
                return Results.Unauthorized();

            var deleteQuery = $@"DELETE FROM HousePhotos WHERE PhotoId IN @filenames";

            await repository.ExecuteAsync(deleteQuery, new { filenames = request.Filenames });

            foreach(string filename in request.Filenames)
                await storage.DeleteFileAsync("housePhotos", filename);

            return Results.Ok();
        }
    }
}
