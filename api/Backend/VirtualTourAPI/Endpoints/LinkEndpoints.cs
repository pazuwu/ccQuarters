using AuthLibrary;
using System.Security.Claims;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Requests;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.Endpoints
{
    public static class LinkEndpoints
    {
        public static async Task<IResult> Post(string tourId, HttpContext context, PostLinkRequest request, 
            ITourService tourService, ILinkService linkService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await tourService.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            Dictionary<string, string[]> errors = new();

            if (string.IsNullOrWhiteSpace(request.ParentId))
                errors.Add(nameof(request.ParentId), new[] { "Is mandatory." });
            if (string.IsNullOrWhiteSpace(request.DestinationId))
                errors.Add(nameof(request.DestinationId), new[] { "Is mandatory." });

            if (errors.Count > 0)
                return Results.ValidationProblem(errors);

            var newLink = new NewLinkDTO()
            {
                ParentId = request.ParentId,
                DestinationId = request.DestinationId,
                Position = request.Position,
                Text = request.Text,
                NextOrientation = request.NextOrientation,
            };

            var createdLinkId = await linkService.CreateLink(tourId, newLink);

            if (string.IsNullOrWhiteSpace(createdLinkId))
                return Results.Problem("DB error occured while creating object.");

            return Results.Created(createdLinkId, null);
        }

        public static async Task<IResult> Put(string tourId, string linkId, HttpContext context, PutLinkRequest request, 
            ITourService tourService, ILinkService linkService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await tourService.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            var link = new LinkDTO()
            {
                Id = linkId,
                DestinationId = request.DestinationId,
                NextOrientation = request.NextOrientation,
                Position = request.Position,
                Text = request.Text,
            };

            await linkService.UpdateLink(tourId, link);
            return Results.Ok();
        }

        public static async Task<IResult> Delete(string tourId, string linkId, HttpContext context, 
            ITourService tourService, ILinkService linkService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || !await tourService.HasUserPermissionToModifyTour(tourId, userId))
                Results.Unauthorized();

            await linkService.DeleteLink(tourId, linkId);
            return Results.Ok();
        }
    }
}
