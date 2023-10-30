﻿using VirtualTourAPI.Model;
using VirtualTourAPI.Repository;
using VirtualTourAPI.Requests;

namespace VirtualTourAPI.Endpoints
{
    public static class LinkEndpoints
    {
        public static async Task<IResult> Post(string tourId, PostLinkRequest request, IVTRepository repository)
        {
            Dictionary<string, string[]> errors = new();

            if (string.IsNullOrWhiteSpace(request.ParentId))
                errors.Add(nameof(request.ParentId), new[] { "Is mandatory." });
            if (string.IsNullOrWhiteSpace(request.DestinationId))
                errors.Add(nameof(request.DestinationId), new[] { "Is mandatory." });
            if (request.Position is null)
                errors.Add(nameof(request.Position), new[] { "Is mandatory." });

            if (errors.Count > 0)
                return Results.ValidationProblem(errors);

            var newLink = new LinkDTO()
            {
                ParentId = request.ParentId,
                DestinationId = request.DestinationId,
                Position = request.Position!.Value,
                Text = request.Text,
                NextOrientation = request.NextOrientation,
            };

            var createdAreaId = await repository.CreateLink(tourId, newLink);

            if (string.IsNullOrWhiteSpace(createdAreaId))
                return Results.Problem("DB error occured while creating object.");

            return Results.Created(tourId, null);
        }

        public static async Task<IResult> Put(string tourId, string linkId, PutLinkRequest request, IVTRepository repository)
        {
            var link = new LinkDTO()
            {
                Id = linkId,
                DestinationId = request.DestinationId,
                NextOrientation = request.NextOrientation,
                Position = request.Position,
                Text = request.Text,
            };

            await repository.UpdateLink(tourId, link);
            return Results.Ok();
        }

        public static async Task<IResult> Delete(string tourId, string linkId, IVTRepository repository)
        {
            await repository.DeleteLink(tourId, linkId);
            return Results.Ok();
        }
    }
}
