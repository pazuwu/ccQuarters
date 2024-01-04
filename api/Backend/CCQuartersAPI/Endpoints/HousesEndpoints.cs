using System.Security.Claims;
using AuthLibrary;
using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.Requests;
using CCQuartersAPI.Responses;
using CCQuartersAPI.Services;
using CloudStorageLibrary;
using Microsoft.AspNetCore.Mvc;
using RepositoryLibrary;

namespace CCQuartersAPI.Endpoints
{
    public class HousesEndpoints
    {
        private const int DEFAULT_PAGE_NUMBER = 0;
        private const int DEFAULT_PAGE_SIZE = 50;

        public static async Task<IResult> GetHouses(HttpContext context, [FromServices] IHousesService housesService, [AsParameters] GetHousesQuery query)
        {
            int pageNumberValue = query.PageNumber ?? DEFAULT_PAGE_NUMBER;
            int pageSizeValue = query.PageSize ?? DEFAULT_PAGE_SIZE;

            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId() ?? string.Empty;

            var houses = await housesService.GetSimpleHousesInfo(query, userId, pageNumberValue, pageSizeValue);

            return Results.Ok(new GetHousesResponse()
            {
                Data = houses?.ToArray(),
                PageNumber = pageNumberValue,
                PageSize = pageSizeValue,
            });
        }

        public static async Task<IResult> GetLikedHouses(HttpContext context, [FromServices] IHousesService housesService, int? pageNumber, int? pageSize)
        {
            int pageNumberValue = pageNumber ?? DEFAULT_PAGE_NUMBER;
            int pageSizeValue = pageSize ?? DEFAULT_PAGE_SIZE;

            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var houses = await housesService.GetSimpleHousesInfoLikedByUser(userId, pageNumberValue, pageSizeValue);

            return Results.Ok(new GetHousesResponse()
            {
                Data = houses?.ToArray(),
                PageNumber = pageNumberValue,
                PageSize = pageSizeValue
            });
        }

        public static async Task<IResult> GetMyHouses(HttpContext context, [FromServices] IHousesService housesService, int? pageNumber, int? pageSize)
        {
            int pageNumberValue = pageNumber ?? DEFAULT_PAGE_NUMBER;
            int pageSizeValue = pageSize ?? DEFAULT_PAGE_SIZE;

            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var houses = await housesService.GetSimpleHousesInfoCreatedByUser(userId, pageNumberValue, pageSizeValue);

            return Results.Ok(new GetHousesResponse()
            {
                Data = houses?.ToArray(),
                PageNumber = pageNumberValue,
                PageSize = pageSizeValue
            });
        }

        public static async Task<IResult> CreateHouse([FromServices] IHousesService housesService, CreateHouseRequest houseRequest, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var houseId = await housesService.CreateHouse(userId, houseRequest);

            return Results.Created(houseId.ToString(), null);
        }

        public static async Task<IResult> GetHouse([FromServices] IHousesService housesService, [FromServices] IHousePhotosService housePhotosService, [FromServices] IUsersService usersService, Guid houseId, HttpContext context, IStorage storage)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId() ?? string.Empty;

            var house = await housesService.GetDetailedHouseInfo(houseId, userId);

            if (house is null)
                return Results.NotFound("House not found");

            var photos = await housePhotosService.GetPhotosForHouse(houseId);

            var user = await usersService.GetUser(house.UserId);

            if (user is not null)
            {
                house.UserName = user.Name;
                house.UserSurname = user.Surname;
                house.UserCompany = user.Company;
                house.UserEmail = user.Email;
                house.UserPhoneNumber = user.PhoneNumber;
            }
            else
                return Results.NotFound("House author not found");

            return Results.Ok(new GetHouseResponse()
            {
                House = house,
                Photos = photos.ToArray()
            });
        }

        public static async Task<IResult> UpdateHouse([FromServices] IHousesService housesService, [FromServices] IDocumentDBRepository documentRepository, Guid houseId, CreateHouseRequest houseRequest, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var houseQueried = await housesService.GetDetailedHouseInfo(houseId, userId);

            if (houseQueried is null)
                return Results.NotFound("House not found");

            if (houseQueried.UserId != userId)
                return Results.Unauthorized();

            await housesService.UpdateHouse(houseId, houseRequest, houseQueried);

            return Results.Ok();
        }

        public static async Task<IResult> DeleteHouse([FromServices] IHousesService housesService, Guid houseId, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var houseQueried = await housesService.GetBasicHouseInfo(houseId);

            if (houseQueried is null)
                return Results.NotFound("House not found");

            if (houseQueried.UserId != userId)
                return Results.Unauthorized();

            await housesService.DeleteHouse(houseId);

            return Results.Ok();
        }

        public static async Task<IResult> LikeHouse([FromServices] IHousesService housesService, Guid houseId, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            await housesService.LikeHouse(userId, houseId);

            return Results.Ok();
        }

        public static async Task<IResult> UnlikeHouse([FromServices] IHousesService housesService, Guid houseId, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            await housesService.UnlikeHouse(userId, houseId);

            return Results.Ok();
        }

        public static async Task<IResult> AddPhoto([FromServices] IHousesService housesService, [FromServices] IHousePhotosService housePhotosService, Guid houseId, IFormFile file, [FromQuery] int order, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var houseQueried = await housesService.GetBasicHouseInfo(houseId);

            if (houseQueried?.UserId != userId)
                return Results.Unauthorized();

            await housePhotosService.AddHousePhoto(houseId, file.OpenReadStream(), order);

            return Results.Ok();
        }

        public static async Task<IResult> DeletePhotos([FromServices] IHousePhotosService housePhotosService, [FromServices] IStorage storage, HttpContext context, [FromBody] DeletePhotosRequest request)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var photosInfo = (await housePhotosService.GetPhotosInfoByNames(request.Filenames))?.ToList();

            if (photosInfo is null || !photosInfo.Any())
                return Results.NotFound("Photos not found");

            if (photosInfo.Any(p => p.UserId != userId))
                return Results.Unauthorized();

            await housePhotosService.DeletePhotosByNames(request.Filenames);

            return Results.Ok();
        }
    }
}
