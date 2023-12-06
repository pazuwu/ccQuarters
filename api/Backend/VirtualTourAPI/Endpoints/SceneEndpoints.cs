using CloudStorageLibrary;
using VirtualTourAPI.Model;
using VirtualTourAPI.Requests;
using VirtualTourAPI.Service;

namespace VirtualTourAPI.Endpoints
{
    public static class SceneEndpoints
    {
        public static async Task<IResult> Post(string tourId, PostSceneRequest request, IVTService service)
        {
            var newScene = new SceneDTO()
            {
                ParentId = request.ParentId,
            };

            var createdSceneId = await service.CreateScene(tourId, newScene);

            if (string.IsNullOrWhiteSpace(createdSceneId))
                return Results.Problem("DB error occured while creating object.");

            return Results.Created(createdSceneId, null);
        }

        public static async Task<IResult> Delete(string tourId, string sceneId, IVTService service)
        {
            await service.DeleteScene(tourId, sceneId);
            return Results.Ok();
        }

        public static async Task<IResult> PostPhoto(string tourId, string sceneId, IFormFile file, IStorage storage)
        {
            using var fileStream = file.OpenReadStream();
            var collectionName = $"tours/{tourId}/scenes";
            var filename = sceneId;

            await storage.UploadFileAsync(collectionName, fileStream, filename);
            var url = await storage.GetDownloadUrl(collectionName, filename);
            return Results.Created(url, null);
        }
    }
}
