﻿using VirtualTourAPI.Model;
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
    }
}
