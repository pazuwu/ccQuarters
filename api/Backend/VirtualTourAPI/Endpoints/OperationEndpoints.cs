using AuthLibrary;
using System.Security.Claims;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.Endpoints
{
    public static class OperationEndpoints
    {
        public static async Task<IResult> Put(string operationId, HttpContext context, 
            VTOperationUpdateDTO operationUpdate, IOperationService operationService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || identity?.RoleClaimType != "infrastacture")
                Results.Unauthorized();

            await operationService.UpdateOperation(operationId, operationUpdate);

            return Results.Ok();
        }

        public static async Task<IResult> Delete(string operationId, HttpContext context, 
            IOperationService operationService)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();

            if (userId == null || (identity != null && identity.FindFirst(c => c.Type == identity.RoleClaimType)?.Value != "infrastructure"))
                Results.Unauthorized();

            await operationService.DeleteOperation(operationId);

            return Results.Ok();
        }
    }
}
