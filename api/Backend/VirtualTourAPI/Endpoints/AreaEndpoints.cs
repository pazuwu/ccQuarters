using AuthLibrary;
using CloudStorageLibrary;
using System.Security.Claims;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.Endpoints
{
    public static class AreaEndpoints
    {
        public static async Task<IResult> Post(string tourId, HttpContext context, NewAreaDTO newArea, 
            ITourService tourService, IAreaService areaService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await tourService.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            var createdAreaId = await areaService.CreateArea(tourId, newArea);

            if (string.IsNullOrWhiteSpace(createdAreaId))
                return Results.Problem("DB error occured while creating object.");

            return Results.Created(createdAreaId, null);
        }

        public static async Task<IResult> Delete(string tourId, string areaId, HttpContext context, 
            ITourService tourService, IAreaService areaService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await tourService.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            await areaService.DeleteArea(tourId, areaId);
            return Results.Ok();
        }

        public static async Task<IResult> PostPhotos(string tourId, string areaId, HttpContext context, 
            IFormFile file, IStorage storage, ITourService tourService, IAreaService areaService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await tourService.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            using var fileStream = file.OpenReadStream();
            var collectionName = $"tours/{tourId}/{areaId}";

            var photoId = await areaService.AddPhotoToArea(tourId, areaId);
            await storage.UploadFileAsync(collectionName, fileStream, photoId);

            return Results.Created(photoId, null);
        }

        public static async Task<IResult> GetPhotos(string tourId, string areaId, IStorage storage, IAreaService areaService)
        {
            var areaPhotosInfo = await areaService.GetAreaPhotosInfo(tourId, areaId);
            var collectionName = $"tours/{tourId}/{areaId}";

            if (areaPhotosInfo == null)
                return Results.NotFound();

            if (areaPhotosInfo.PhotoIds != null)
            {
                var urls = await storage.GetDownloadUrls(collectionName, areaPhotosInfo.PhotoIds);
                return Results.Ok(urls.ToArray());
            }

            return Results.Ok(Array.Empty<string>());
        }

        public static async Task<IResult> Process(string tourId, string areaId, HttpContext context, 
            ITourService tourService, IOperationService operationService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await tourService.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            var userEmail = identity?.FindFirst("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress")?.Value;

            if(userEmail == null) 
                return Results.BadRequest("User email not found in user token");

            var operationId = await operationService.CreateOperation(tourId, areaId, userEmail);

            if (operationId == null)
                return Results.Conflict();

            return Results.Accepted(operationId);
        }
    }
}
