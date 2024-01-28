using AuthLibrary;
using CloudStorageLibrary;
using System.Security.Claims;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.Endpoints
{
    public static class SceneEndpoints
    {
        public static async Task<IResult> Post(string tourId, HttpContext context, NewSceneDTO newScene, 
            ITourService tourService, ISceneService sceneService, IAreaService areaService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await tourService.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            if(string.IsNullOrWhiteSpace(newScene.Name) && newScene.ParentId != null)
            {
                var relatedArea = await areaService.GetArea(tourId, newScene.ParentId!);
                newScene.Name = relatedArea?.Name ?? newScene.Name;
            }

            var createdSceneId = await sceneService.CreateScene(tourId, newScene);

            if (string.IsNullOrWhiteSpace(createdSceneId))
                return Results.Problem("DB error occured while creating object.");

            return Results.Created(createdSceneId, "");
        }

        public static async Task<IResult> Delete(string tourId, string sceneId, HttpContext context, 
            ITourService tourService, ISceneService sceneService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await tourService.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            await sceneService.DeleteScene(tourId, sceneId);
            return Results.Ok();
        }

        public static async Task<IResult> PostPhoto(string tourId, string sceneId, HttpContext context, 
            IFormFile file, ITourService service, IStorage storage)
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

        public static async Task<IResult> Put(string tourId, string sceneId, HttpContext context, 
            ISceneService sceneService, ITourService tourService, SceneUpdateDTO sceneUpdate)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await tourService.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            await sceneService.UpdateScene(tourId, sceneId, sceneUpdate);

            return Results.Ok();
        }
    }
}
