using System.Security.Claims;
using AuthLibrary;
using Microsoft.AspNetCore.Mvc;
using CCQuartersAPI.Services;
using CCQuartersAPI.AlertsDTOs;

namespace CCQuartersAPI.Endpoints
{
    public class AlertsEndpoints
    {
        private const int DEFAULT_PAGE_NUMBER = 0;
        private const int DEFAULT_PAGE_SIZE = 50;

        public static async Task<IResult> GetAlerts([FromServices] IAlertsService service, HttpContext context, int? pageNumber, int? pageSize)
        {
            int pageNumberValue = pageNumber ?? DEFAULT_PAGE_NUMBER;
            int pageSizeValue = pageSize ?? DEFAULT_PAGE_SIZE;

            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var alerts = await service.GetAlerts(userId, pageNumberValue, pageSizeValue);

            return Results.Ok(new GetAlertsResponse
            {
                Data = alerts,
                PageNumber = pageNumberValue,
                PageSize = pageSizeValue
            });
        }

        public static async Task<IResult> CreateAlert([FromServices] IAlertsService service, CreateAlertRequest alertRequest, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var alertId = await service.CreateAlert(alertRequest, userId);

            if (alertId is null)
                return Results.StatusCode(500);

            return Results.Created(alertId.Value.ToString(), null);
        }

        public static async Task<IResult> UpdateAlert([FromServices] IAlertsService alertsService, Guid alertId, UpdateAlertRequest alertRequest, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var alertQueried = await alertsService.GetAlertById(alertId);

            if (alertQueried is null)
                return Results.NotFound("Alert does not exist");

            if(userId != alertQueried.UserId) 
                return Results.Unauthorized();

            await alertsService.UpdateAlert(alertRequest, alertId);

            return Results.Ok();
        }

        public static async Task<IResult> DeleteAlert([FromServices] IAlertsService alertsService, Guid alertId, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var alertQueried = await alertsService.GetAlertById(alertId);

            if (alertQueried is null)
                return Results.NotFound("Alert does not exist");

            if (userId != alertQueried.UserId)
                return Results.Unauthorized();

            await alertsService.DeleteAlertById(alertId);

            return Results.Ok();
        }
    }
}
