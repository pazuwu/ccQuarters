using CCQuartersAPI.Responses;
using System.Security.Claims;
using AuthLibrary;
using Microsoft.AspNetCore.Mvc;
using CCQuartersAPI.Services;

namespace CCQuartersAPI.Endpoints
{
    public class AlertsEndpoints
    {
        public static async Task<IResult> GetAlerts([FromServices] IAlertsService service, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var alerts = await service.GetAlerts(userId);

            return Results.Ok(new GetAlertsResponse
            {
                Alerts = alerts
            });
        }

        public static async Task<IResult> CreateAlert([FromServices] IAlertsService service, AlertDTO alert, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            await service.CreateAlert(alert, userId);

            return Results.Ok();
        }

        public static async Task<IResult> UpdateAlert([FromServices] IAlertsService alertsService, Guid alertId, AlertDTO alert, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? userId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(userId))
                return Results.Unauthorized();

            var alertQueried = await alertsService.GetAlertById(alertId);

            if (alertQueried is null)
                return Results.NotFound("Alert does not exist");

            if(userId != alertQueried.UserId) 
                return Results.Unauthorized();

            await alertsService.UpdateAlert(alert, alertId);

            return Results.Ok();
        }

        public static async Task<IResult> DeleteAlert([FromServices] IAlertsService alertsService, Guid alertId, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
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
