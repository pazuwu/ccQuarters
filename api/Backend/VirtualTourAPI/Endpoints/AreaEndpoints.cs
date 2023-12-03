using AuthLibrary;
using CloudStorageLibrary;
using System.Collections;
using VirtualTourAPI.Model;
using VirtualTourAPI.Requests;
using VirtualTourAPI.Service;

namespace VirtualTourAPI.Endpoints
{
    public static class AreaEndpoints
    {
        public static async Task<IResult> Post(string tourId, PostAreaRequest request, IVTService repository)
        {
            var createdAreaId = await repository.CreateArea(tourId, new AreaDTO() { Name = request.Name });

            if (string.IsNullOrWhiteSpace(createdAreaId))
                return Results.Problem("DB error occured while creating object.");

            return Results.Created(createdAreaId, null);
        }

        public static async Task<IResult> Delete(string tourId, string areaId, IVTService repository)
        {
            await repository.DeleteArea(tourId, areaId);
            return Results.Ok();
        }

        public static async Task<IResult> PostPhotos(string tourId, string areaId, IFormFile file, IStorage storage, IVTService repository)
        {
            using var fileStream = file.OpenReadStream();
            var collectionName = $"tours/{tourId}/{areaId}";
            var filename = Guid.NewGuid().ToString();

            await storage.UploadFileAsync(collectionName, fileStream, filename);
            await repository.AddPhotoToArea(tourId, areaId, filename);

            var url = await storage.GetDownloadUrl(collectionName, filename);
            return Results.Created(url, null);
        }

        public static async Task<IResult> GetPhotos(string tourId, string areaId, IStorage storage, IVTService repository)
        {
            var area = await repository.GetArea(tourId, areaId);
            var collectionName = $"tours/{tourId}/{areaId}";

            if (area == null)
                return Results.NotFound();

            if (area.PhotoIds != null)
            {
                var urls = await storage.GetDownloadUrls(collectionName, area.PhotoIds);
                return Results.Ok(urls.ToArray());
            }

            return Results.Ok(Array.Empty<string>());
        }

        public static async Task<IResult> Process(string tourId, string areaId, IVTService repository)
        {
            var operationId = await repository.CreateOperation(tourId, areaId);

            if (operationId == null)
                return Results.Conflict();

            return Results.Accepted(operationId);
        }
    }
}
