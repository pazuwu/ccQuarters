using AuthLibrary;
using CCQuartersAPI.Requests;
using CCQuartersAPI.Services;
using Google.Api;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CCQuartersAPI.Endpoints
{
    public class UsersEndpoints
    {
        public static async Task<IResult> GetUser([FromServices] IUsersService usersService, string userId, HttpContext context) 
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            var user = await usersService.GetUser(userId);

            if (user is null)
                return Results.NotFound("User does not exist.");

            return Results.Ok(user);
        }

        public static async Task<IResult> UpdateUser([FromServices] IUsersService usersService, string userId, UpdateUserRequest request, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? tokenUserId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(tokenUserId) || tokenUserId != userId)
                return Results.Unauthorized();

            await usersService.UpdateUser(userId, request);

            return Results.Ok();
        }

        public static async Task<IResult> DeleteUser([FromServices] IUsersService usersService, string userId, HttpContext context) 
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? tokenUserId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(tokenUserId) || userId != tokenUserId)
                return Results.Unauthorized();

            await usersService.DeleteUser(userId);

            return Results.Ok();
        }

        public static async Task<IResult> ChangePhoto([FromServices] IUsersService usersService, string userId, IFormFile file, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? tokenUserId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(tokenUserId) || userId != tokenUserId)
                return Results.Unauthorized();

            await usersService.ChangeUserPhoto(userId, file.OpenReadStream());

            return Results.Ok();
        }

        public static async Task<IResult> DeletePhoto([FromServices] IUsersService usersService, string userId, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;

            if (identity?.IsAnonymous() != false)
                return Results.Unauthorized();

            string? tokenUserId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(tokenUserId) || userId != tokenUserId)
                return Results.Unauthorized();

            await usersService.DeleteUserPhoto(userId);

            return Results.Ok();
        }
    }
}
