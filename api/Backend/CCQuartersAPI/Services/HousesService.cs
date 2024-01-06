using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.Mappers;
using CCQuartersAPI.Requests;
using CCQuartersAPI.Responses;
using CloudStorageLibrary;
using RepositoryLibrary;
using System.Data;
using System.Text;

namespace CCQuartersAPI.Services
{
    public class HousesService : IHousesService
    {
        private readonly IRelationalDBRepository _rdbRepository;
        private readonly IDocumentDBRepository _documentRepository;
        private readonly IStorage _storage;

        private readonly string AdditionalInfoCollection = "additionalInfos";
        private readonly string DescriptionCollection = "descriptions";
        private readonly string HousePhotosCollection = "housePhotos";

        public HousesService(IRelationalDBRepository rdbRepository, IDocumentDBRepository documentRepository, IStorage storage)
        {
            _rdbRepository = rdbRepository;
            _documentRepository = documentRepository;
            _storage = storage;
        }

        public async Task<Guid> CreateHouse(string userId, CreateHouseRequest houseRequest)
        {
            using var trans = _rdbRepository.BeginTransaction();
            try
            {
                string additionalInfoId = await _documentRepository.AddAsync(AdditionalInfoCollection, houseRequest.AdditionalInfo ?? new Dictionary<string, string>());

                string descriptionId = await _documentRepository.AddAsync(DescriptionCollection, new Dictionary<string, object>()
                    {
                        {nameof(houseRequest.Description), houseRequest.Description ?? "" }
                    });

                var locationQuery = @$"INSERT INTO Locations (Id, City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, GeoX, GeoY)
                                    OUTPUT INSERTED.Id
                                    VALUES (NEWID(), @city, @voivodeship, @zipCode, @district, @streetName, @streetNumber, @flatNumber, @geoX, @geoY)";

                var locationId = await _rdbRepository.QueryFirstAsync<Guid>(locationQuery, transaction: trans, param: new
                {
                    city = houseRequest.City,
                    voivodeship = houseRequest.Voivodeship,
                    zipCode = houseRequest.ZipCode,
                    district = houseRequest.District,
                    streetName = houseRequest.StreetName,
                    streetNumber = houseRequest.StreetNumber,
                    flatNumber = houseRequest.FlatNumber,
                    geoX = houseRequest.GeoX,
                    geoY = houseRequest.GeoY,
                });

                var detailsQuery = @$"INSERT INTO Details (Id, DescriptionId, Price, RoomCount, Area, Floor, BuildingType, AdditionalInfoId, VirtualTourId, Title)
                                    OUTPUT INSERTED.Id
                                    VALUES (NEWID(), @descriptionId, @price, @roomCount, @area, @floor, @buildingType, @additionalInfoId, @virtualTourId, @title)";

                var detailsId = await _rdbRepository.QueryFirstAsync<Guid>(detailsQuery, transaction: trans, param: new
                {
                    descriptionId,
                    price = houseRequest.Price,
                    roomCount = houseRequest.RoomCount,
                    area = houseRequest.Area,
                    floor = houseRequest.Floor,
                    buildingType = (int?)houseRequest.BuildingType,
                    additionalInfoId,
                    virtualTourId = houseRequest.VirtualTourId,
                    title = houseRequest.Title,
                });

                var houseQuery = @$"INSERT INTO Houses (Id, UserId, LocationId, DetailsId, CreationDate, UpdateDate, OfferType)
                                    OUTPUT INSERTED.Id
                                    VALUES (NEWID(), @userId, @locationId, @detailsId, GETDATE(), GETDATE(), @offerType)";

                var createdHouseId = await _rdbRepository.QueryFirstAsync<Guid>(houseQuery, transaction: trans, param: new
                {
                    userId,
                    locationId,
                    detailsId,
                    offerType = (int?)houseRequest.OfferType,
                });

                _rdbRepository.CommitTransaction(transaction: trans);

                return createdHouseId;
            }
            catch
            {
                _rdbRepository.RollbackTransaction(transaction: trans);
                throw;
            }
        }

        public async Task UpdateHouse(Guid houseId, CreateHouseRequest houseRequest, DetailedHouseDTO houseQueried)
        {
            using var trans = _rdbRepository.BeginTransaction();
            try
            {
                if (houseRequest.AdditionalInfo is not null)
                    await _documentRepository.SetAsync($"{AdditionalInfoCollection}/{houseQueried.AdditionalInfoId}", houseRequest.AdditionalInfo);

                if (houseRequest.Description is not null)
                    await _documentRepository.SetAsync($"{DescriptionCollection}/{houseQueried.DescriptionId}", new Dictionary<string, object>()
                        {
                            {nameof(houseRequest.Description), houseRequest.Description ?? "" }
                        });

                var locationQuery = @$"UPDATE Locations
                                    SET  City = @city, Voivodeship = @voivodeship, ZipCode = @zipCode, District = @district, StreetName = @streetName, StreetNumber = @streetNumber, FlatNumber = @flatNumber, GeoX = @geoX, GeoY = @geoY
                                    WHERE Id IN (SELECT LocationId FROM Houses WHERE Id = @houseId)";

                await _rdbRepository.ExecuteAsync(locationQuery, transaction: trans, param: new
                {
                    city = houseRequest.City ?? houseQueried.City,
                    voivodeship = houseRequest.Voivodeship ?? houseQueried.Voivodeship,
                    zipCode = houseRequest.ZipCode ?? houseQueried.ZipCode,
                    district = houseRequest.District ?? houseQueried.District,
                    streetName = houseRequest.StreetName ?? houseQueried.StreetName,
                    streetNumber = houseRequest.StreetNumber ?? houseQueried.StreetNumber,
                    flatNumber = houseRequest.FlatNumber ?? houseQueried.FlatNumber,
                    geoX = houseRequest.GeoX ?? houseQueried.GeoX,
                    geoY = houseRequest.GeoY ?? houseQueried.GeoY,
                    houseId
                });

                var detailsQuery = @$"UPDATE Details
                                    SET Price = @price, RoomCount = @roomCount, Area = @area, Floor = @floor, BuildingType = @buildingType, Title = @title, VirtualTourId = @virtualTourId
                                    WHERE Id IN (SELECT DetailsId FROM Houses WHERE Id = @houseId)";

                await _rdbRepository.ExecuteAsync(detailsQuery, transaction: trans, param: new
                {
                    price = houseRequest.Price ?? houseQueried.Price,
                    roomCount = houseRequest.RoomCount ?? houseQueried.RoomCount,
                    area = houseRequest.Area ?? houseQueried.Area,
                    floor = houseRequest.Floor ?? houseQueried.Floor,
                    buildingType = (int?)houseRequest.BuildingType ?? (int?)houseQueried.BuildingType,
                    title = houseRequest.Title ?? houseQueried.Title,
                    virtualTourId = houseRequest.VirtualTourId,
                    houseId
                });

                var houseUpdateQuery = @$"UPDATE Houses 
                                        SET UpdateDate = GETDATE(), OfferType = @offerType
                                        WHERE Id = @houseId";

                await _rdbRepository.ExecuteAsync(houseUpdateQuery, transaction: trans, param: new
                {
                    offerType = (int?)houseRequest.OfferType ?? (int?)houseQueried.OfferType,
                    houseId
                });

                _rdbRepository.CommitTransaction(transaction: trans);
            }
            catch
            {
                _rdbRepository.RollbackTransaction(transaction: trans);
                throw;
            }
        }

        public async Task DeleteHouse(Guid houseId)
        {
            var deleteQuery = @$"UPDATE Houses
                        SET DeleteDate = GETDATE()
                        WHERE Id = @houseId";

            await _rdbRepository.ExecuteAsync(deleteQuery, new { houseId });
        }

        public async Task LikeHouse(string userId, Guid houseId)
        {
            var query = @$"IF NOT EXISTS (SELECT * FROM LikedHouses WHERE HouseId = @houseId AND UserId = @userId)
                       BEGIN
                           INSERT INTO LikedHouses 
                           VALUES (@userId, @houseId, GETDATE())
                       END";

            await _rdbRepository.ExecuteAsync(query, new { userId, houseId });
        }

        public async Task UnlikeHouse(string userId, Guid houseId)
        {
            var query = @$"DELETE FROM LikedHouses WHERE UserId = @userId AND HouseId = @houseId";

            await _rdbRepository.ExecuteAsync(query, new { userId, houseId });
        }

        public async Task<BasicHouseInfoDTO?> GetBasicHouseInfo(Guid houseId)
        {
            var query = @"SELECT Id, UserId
                          FROM Houses
                          WHERE Id = @houseId AND DeleteDate IS NULL";

            return await _rdbRepository.QueryFirstOrDefaultAsync<BasicHouseInfoDTO>(query, new { houseId });
        }

        public async Task<IEnumerable<SimpleHouseDTO>?> GetSimpleHousesInfo(GetHousesQuery housesQuery, string userId, int pageNumber, int pageSize)
        {
            var queryBuilder = new StringBuilder();

            var query = @$"SELECT h.Id AS Id, Title, Price, RoomCount, Area, [Floor], City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, CreationDate, UpdateDate, IIF((SELECT COUNT(*) FROM LikedHouses WHERE HouseId = h.Id AND UserId = @userId)>0, 1, 0) AS IsLiked, PhotoId AS PhotoUrl
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        LEFT JOIN HousePhotos p ON p.HouseId = h.Id AND [Order] = (SELECT TOP 1 [Order] FROM HousePhotos WHERE HouseId = h.Id ORDER BY [Order])
                        WHERE h.DeleteDate IS NULL AND ";

            queryBuilder.Append(query);

            queryBuilder.Append(ParseGetHousesQuery(housesQuery));

            queryBuilder.AppendLine();
            queryBuilder.Append($@" OFFSET @pageNumber * @pageSize ROWS
                                FETCH NEXT @pageSize ROWS ONLY");

            return await GetSimpleHousesInfoInternal(queryBuilder.ToString(), new
            {
                userId,
                title = $"%{housesQuery.Title}%",
                minPrice = housesQuery.MinPrice,
                maxPrice = housesQuery.MaxPrice,
                minPricePerM2 = housesQuery.MinPricePerM2,
                maxPricePerM2 = housesQuery.MaxPricePerM2,
                maxArea = housesQuery.MaxArea,
                minArea = housesQuery.MinArea,
                maxRoomCount = housesQuery.MaxRoomCount,
                minRoomCount = housesQuery.MinRoomCount,
                floors = housesQuery.Floors,
                minFloor = housesQuery.MinFloor,
                maxFloor = housesQuery.MaxFloor,
                offerType = (int?)housesQuery.OfferType,
                buildingType = (int?)housesQuery.BuildingType,
                voivodeship = housesQuery.Voivodeship,
                cities = housesQuery.Cities,
                districts = housesQuery.Districts,
                pageNumber,
                pageSize
            });
        }

        private string ParseGetHousesQuery(GetHousesQuery query)
        {
            var sb = new StringBuilder("1=1");

            if (query.Title is not null)
                sb.Append($@" AND Title like @title");
            if (query.MinPrice is not null)
                sb.Append($@" AND Price >= @minPrice");
            if (query.MaxPrice is not null)
                sb.Append($@" AND Price <= @maxPrice");
            if (query.MinPricePerM2 is not null)
                sb.Append($@" AND Price / Area >= @minPricePerM2");
            if (query.MaxPricePerM2 is not null)
                sb.Append($@" AND Price / Area <= @maxPricePerM2");
            if (query.MaxArea is not null)
                sb.Append($@" AND Area <= @maxArea");
            if (query.MinArea is not null)
                sb.Append($@" AND Area >= @minArea");
            if (query.MaxRoomCount is not null)
                sb.Append($@" AND RoomCount <= @maxRoomCount");
            if (query.MinRoomCount is not null)
                sb.Append($@" AND RoomCount >= @minRoomCount");
            if (query.Floors is not null && query.Floors.Any())
                sb.Append($@" AND Floor IN @floors");
            if (query.MinFloor is not null)
                sb.Append($@" AND Floor >= @minFloor");
            if (query.MaxFloor is not null)
                sb.Append($@" AND Floor <= @maxFloor");
            if (query.OfferType is not null)
                sb.Append($@" AND OfferType = @offerType");
            if (query.BuildingType is not null)
                sb.Append($@" AND BuildingType = @buildingType");
            if (query.Voivodeship is not null)
                sb.Append($@" AND Voivodeship = @voivodeship");
            if (query.Cities is not null && query.Cities.Any())
                sb.Append($@" AND City IN @cities");
            if (query.Districts is not null && query.Districts.Any())
                sb.Append($@" AND District IN @districts");

            sb.Append($@" ORDER BY ");
            switch (query.SortMethod)
            {
                case SortingMethod.ByPriceAscending:
                    sb.Append("d.Price ");
                    break;
                case SortingMethod.ByPriceDescending:
                    sb.Append("d.Price DESC ");
                    break;
                case SortingMethod.ByPricePerM2Ascending:
                    sb.Append("d.Price / d.Area ");
                    break;
                case SortingMethod.ByPricePerM2Descending:
                    sb.Append("d.Price / d.Area DESC ");
                    break;
                case SortingMethod.ByUpdateDateDescending:
                case null:
                default:
                    sb.Append("h.UpdateDate DESC ");
                    break;
            }

            return sb.ToString();
        }

        public async Task<IEnumerable<SimpleHouseDTO>?> GetSimpleHousesInfoCreatedByUser(string userId, int pageNumber, int pageSize)
        {
            var query = @$"SELECT h.Id AS Id, Title, Price, RoomCount, Area, [Floor], City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, CreationDate, UpdateDate, 1 AS IsLiked, PhotoId AS PhotoUrl
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        LEFT JOIN HousePhotos p ON p.HouseId = h.Id AND [Order] = (SELECT TOP 1 [Order] FROM HousePhotos WHERE HouseId = h.Id ORDER BY [Order])
                        WHERE UserId = @userId AND h.DeleteDate IS NULL
                        ORDER BY h.UpdateDate DESC
                        OFFSET @pageNumber * @pageSize ROWS
                        FETCH NEXT @pageSize ROWS ONLY";

            return await GetSimpleHousesInfoInternal(query, new
            {
                userId,
                pageNumber,
                pageSize
            });
        }

        public async Task<IEnumerable<SimpleHouseDTO>?> GetSimpleHousesInfoLikedByUser(string userId, int pageNumber, int pageSize)
        {
            var query = @$"SELECT h.Id AS Id, Title, Price, RoomCount, Area, [Floor], City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, CreationDate, UpdateDate, 1 AS IsLiked, PhotoId AS PhotoUrl
                        FROM Houses h
                        JOIN Details d ON h.DetailsId = d.Id
                        JOIN Locations l ON h.LocationId = l.Id
                        LEFT JOIN HousePhotos p ON p.HouseId = h.Id AND [Order] = (SELECT TOP 1 [Order] FROM HousePhotos WHERE HouseId = h.Id ORDER BY [Order]) 
                        WHERE (SELECT COUNT(*) FROM LikedHouses WHERE HouseId = h.Id AND UserId = @userId) > 0 AND h.DeleteDate IS NULL
                        ORDER BY (SELECT TOP 1 LikeDate FROM LikedHouses WHERE HouseId = h.Id AND UserId = @userId ORDER BY LikeDate DESC) DESC
                        OFFSET @pageNumber * @pageSize ROWS
                        FETCH NEXT @pageSize ROWS ONLY";

            return await GetSimpleHousesInfoInternal(query, new
            {
                userId,
                pageNumber,
                pageSize
            });
        }

        private async Task<IEnumerable<SimpleHouseDTO>?> GetSimpleHousesInfoInternal(string query, object param)
        {
            var houses = await _rdbRepository.QueryAsync<SimpleHouseDTO>(query, param);

            foreach (var house in houses)
                if (!string.IsNullOrWhiteSpace(house.PhotoUrl))
                    house.PhotoUrl = await _storage.GetDownloadUrl(HousePhotosCollection, house.PhotoUrl);

            return houses;
        }

        public async Task<DetailedHouseDTO?> GetDetailedHouseInfo(Guid houseId, string userId)
        {
            var houseQuery = @$"SELECT Title, Price, RoomCount, Area, [Floor], City, Voivodeship, ZipCode, District, StreetName, StreetNumber, FlatNumber, OfferType, BuildingType, IIF((SELECT COUNT(*) FROM LikedHouses WHERE HouseId = h.Id AND UserId = @userId)>0, 1, 0) AS IsLiked, DescriptionId, AdditionalInfoId, VirtualTourId, UserId, GeoX, GeoY
                                FROM Houses h
                                JOIN Details d ON h.DetailsId = d.Id
                                JOIN Locations l ON h.LocationId = l.Id
                                WHERE h.Id = @houseId AND h.DeleteDate IS NULL";

            var houseQueried = await _rdbRepository.QueryFirstOrDefaultAsync<DetailedHouseQueried>(houseQuery, param: new { userId, houseId });

            if (houseQueried is null)
                return null;

            var house = houseQueried.Map();

            if (!string.IsNullOrWhiteSpace(houseQueried.DescriptionId))
                house.Description = (await _documentRepository.GetAsync($"{DescriptionCollection}/{houseQueried.DescriptionId}"))?.ToDictionary().FirstOrDefault().Value?.ToString() ?? string.Empty;

            if (!string.IsNullOrWhiteSpace(house.AdditionalInfoId))
                house.AdditionalInfo = (await _documentRepository.GetAsync($"{AdditionalInfoCollection}/{houseQueried.AdditionalInfoId}"))?.ToDictionary();

            return house;
        }
    }
}
