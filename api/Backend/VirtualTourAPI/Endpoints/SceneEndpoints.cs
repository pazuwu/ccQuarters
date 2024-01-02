using AuthLibrary;
using CloudStorageLibrary;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Service;

namespace VirtualTourAPI.Endpoints
{
    public static class SceneEndpoints
    {
        public static async Task<IResult> Post(string tourId, HttpContext context, NewSceneDTO newScene, IVTService service)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await service.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            var createdSceneId = await service.CreateScene(tourId, newScene);

            if (string.IsNullOrWhiteSpace(createdSceneId))
                return Results.Problem("DB error occured while creating object.");

            return Results.Created(createdSceneId, "");
        }

        public static async Task<IResult> Delete(string tourId, string sceneId, HttpContext context, IVTService service)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await service.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            await service.DeleteScene(tourId, sceneId);
            return Results.Ok();
        }

        public static async Task<IResult> PostPhoto(string tourId, string sceneId, HttpContext context, IFormFile file, IVTService service, IStorage storage)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await service.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            using var fileStream = file.OpenReadStream();
            var collectionName = $"tours/{tourId}/scenes";
            var filename = sceneId;

            await storage.UploadFileAsync(collectionName, fileStream, filename);
            var url = await storage.GetDownloadUrl(collectionName, filename);
            return Results.Created(url, null);
        }
    }
}
