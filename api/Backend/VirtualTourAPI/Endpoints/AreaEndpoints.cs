﻿using AuthLibrary;
using CloudStorageLibrary;
using System.Security.Claims;
using VirtualTourAPI.Model;
using VirtualTourAPI.Requests;
using VirtualTourAPI.Service;

namespace VirtualTourAPI.Endpoints
{
    public static class AreaEndpoints
    {
        public static async Task<IResult> Post(string tourId, HttpContext context, PostAreaRequest request, IVTService service)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await service.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            var createdAreaId = await service.CreateArea(tourId, new AreaDTO() { Name = request.Name });

            if (string.IsNullOrWhiteSpace(createdAreaId))
                return Results.Problem("DB error occured while creating object.");

            return Results.Created(createdAreaId, null);
        }

        public static async Task<IResult> Delete(string tourId, string areaId, HttpContext context, IVTService service)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await service.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            await service.DeleteArea(tourId, areaId);
            return Results.Ok();
        }

        public static async Task<IResult> PostPhotos(string tourId, string areaId, HttpContext context, IFormFile file, IStorage storage, IVTService service)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await service.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            using var fileStream = file.OpenReadStream();
            var collectionName = $"tours/{tourId}/{areaId}";
            var filename = Guid.NewGuid().ToString();

            await storage.UploadFileAsync(collectionName, fileStream, filename);
            await service.AddPhotoToArea(tourId, areaId, filename);

            return Results.Created(filename, null);
        }

        public static async Task<IResult> GetPhotos(string tourId, string areaId, IStorage storage, IVTService service)
        {
            var area = await service.GetArea(tourId, areaId);
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

        public static async Task<IResult> Process(string tourId, string areaId, HttpContext context, IVTService service)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await service.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            var operationId = await service.CreateOperation(tourId, areaId);

            if (operationId == null)
                return Results.Conflict();

            return Results.Accepted(operationId);
        }
    }
}
