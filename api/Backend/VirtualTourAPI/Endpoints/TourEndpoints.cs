using CloudStorageLibrary;
using AuthLibrary;
using System.Security.Claims;
using VirtualTourAPI.Service;
using VirtualTourAPI.Model;
using VirtualTourAPI.Requests;
using Microsoft.AspNetCore.Mvc;

namespace VirtualTourAPI.Endpoints
{
    public static class TourEndpoints
    {
        public static async Task<IResult> Get(string tourId, IVTService service, IStorage storage)
        {
            var tour = await service.GetTour(tourId);

            if (tour == null)
                return Results.NotFound();

            if(tour.Scenes != null)
            {
                foreach (var scene in tour.Scenes)
                {
                    if(scene.Id != null)
                        scene.Photo360Url = await storage.GetDownloadUrl($"tours/{tourId}/scenes", scene.Id);
                }
            }

            return Results.Ok(tour);
        }

        public static async Task<IResult> GetMy(HttpContext context, IVTService service)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null)
                Results.Unauthorized();

            var tours = await service.GetAllUserTourInfos(userId!);
            return Results.Ok(tours);
        }

        public static async Task<IResult> Post(PostTourRequest postTourRequest, HttpContext context, IVTService service)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null)
                Results.Unauthorized();

            var tour = new TourDTO()
            {
                Name = postTourRequest.Name,
                OwnerId = userId!,
            };

            var tourId = await service.CreateTour(tour);

            if (tourId == null)
                return Results.Problem("An error occured while creating new tour in database");

            return Results.Created(tourId, null);
        }

        public static async Task<IResult> Put(string tourId, PutTourRequest putTourRequest, HttpContext context, IVTService service)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null)
                Results.Unauthorized();

            var tour = new TourUpdate()
            {
                Name = putTourRequest.Name,
                PrimarySceneId = putTourRequest.PrimarySceneId
            };

            await service.UpdateTour(tourId, tour);

            return Results.Ok();
        }

        public static async Task<IResult> Delete([FromBody]string[] tourIds, HttpContext context, IVTService service)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if(userId == null)
                Results.Unauthorized();

            foreach (var tourId in tourIds)
            {
                if (!await service.HasUserPermissionToModifyTour(tourId, userId!))
                    continue;

                await service.DeleteTour(tourId);
            }

            return Results.Ok();
        }
    }
}
