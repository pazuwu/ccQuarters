using AuthLibrary;
using System.Security.Claims;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.Endpoints
{
    public static class OperationEndpoints
    {
        public static async Task<IResult> Put(string tourId, string operationId, HttpContext context, 
            VTOperationUpdateDTO operationUpdate, ITourService tourService, IOperationService operationService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || identity?.RoleClaimType != "infrastacture")
                Results.Unauthorized();

            await operationService.UpdateOperation(tourId, operationId, operationUpdate);

            return Results.Ok();
        }

        public static async Task<IResult> Delete(string tourId, string operationId, HttpContext context, 
            IOperationService operationService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || identity?.RoleClaimType != "infrastacture")
                Results.Unauthorized();

            await operationService.DeleteOperation(tourId, operationId);

            return Results.Ok();
        }
    }
}
