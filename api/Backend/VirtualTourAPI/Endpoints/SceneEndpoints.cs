using CloudStorageLibrary;
using VirtualTourAPI.Model;
using VirtualTourAPI.Repository;
using VirtualTourAPI.Requests;

namespace VirtualTourAPI.Endpoints
{
    public static class SceneEndpoints
    {
        public static async Task<IResult> Post(string tourId, PostSceneRequest request, IVTRepository repository)
        {
            Dictionary<string, string[]> validationErrors = new();

            if (string.IsNullOrWhiteSpace(request.ParentId))
                validationErrors.Add(nameof(request.ParentId), new[] { "Is mandatory." });

            if (validationErrors.Count > 0)
                return Results.ValidationProblem(validationErrors);

            var newScene = new SceneDTO()
            {
                ParentId = request.ParentId,
                Photo360Id = request.Photo360Id,
            };

            var createdSceneId = await repository.CreateScene(tourId, newScene);

            if (string.IsNullOrWhiteSpace(createdSceneId))
                return Results.Problem("DB error occured while creating object.");

            return Results.Created(createdSceneId, null);
        }

        public static async Task<IResult> Delete(string tourId, string sceneId, IVTRepository repository)
        {
            await repository.DeleteScene(tourId, sceneId);
            return Results.Ok();
        }

        public static async Task<IResult> PostPhoto(string tourId, string sceneId, IFormFile file, IStorage storage)
        {
            using var fileStream = file.OpenReadStream();
            await storage.UploadFileAsync($"tours/{tourId}/scenes", fileStream, sceneId);
            return Results.Ok();
        }
    }
}
