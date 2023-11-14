using AuthLibrary;
using CloudStorageLibrary;
using System.Collections;
using VirtualTourAPI.Model;
using VirtualTourAPI.Repository;
using VirtualTourAPI.Requests;

namespace VirtualTourAPI.Endpoints
{
    public static class AreaEndpoints
    {
        public static async Task<IResult> Post(string tourId, PostAreaRequest request, IVTRepository repository)
        {
            var createdAreaId = await repository.CreateArea(tourId, new AreaDTO() { Name = request.Name });

            if (string.IsNullOrWhiteSpace(createdAreaId))
                return Results.Problem("DB error occured while creating object.");

            return Results.Created(tourId, null);
        }

        public static async Task<IResult> Delete(string tourId, string areaId, IVTRepository repository)
        {
            await repository.DeleteArea(tourId, areaId);
            return Results.Ok();
        }

        public static async Task<IResult> PostPhotos(string tourId, string areaId, IFormFile file, IStorage storage, IVTRepository repository)
        {
            using var fileStream = file.OpenReadStream();
            var collectionName = $"tours/{tourId}/{areaId}";
            var filename = Guid.NewGuid().ToString();

            await storage.UploadFileAsync(collectionName, fileStream, filename);
            await repository.AddPhotoToArea(tourId, areaId, filename);

            var url = await storage.GetDownloadUrl(collectionName, filename);
            return Results.Created(url, null);
        }

        public static async Task<IResult> Process(string tourId, string areaId, IVTRepository repository)
        {
            var operationId = await repository.CreateOperation(tourId, areaId);

            if (operationId == null) 
                return Results.Conflict();

            return Results.Accepted(operationId);
        }
    }
}
