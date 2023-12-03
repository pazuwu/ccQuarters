using AuthLibrary;
using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.Mappers;
using CCQuartersAPI.Requests;
using CloudStorageLibrary;
using Microsoft.AspNetCore.Mvc;
using RepositoryLibrary;
using System.Security.Claims;

namespace CCQuartersAPI.Endpoints
{
    public class UsersEndpoints
    {

        public static async Task<IResult> GetUser([FromServices] IDocumentDBRepository documentRepository, string userId, IStorage storage) 
        {
            var user = await documentRepository.GetUser(userId, storage);

            if (user is null)
                return Results.NotFound("User does not exist.");

            return Results.Ok(user);
        }
        public static async Task<IResult> UpdateUser([FromServices] IDocumentDBRepository documentRepository, string userId, UpdateUserRequest request, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? tokenUserId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(tokenUserId) || tokenUserId != userId)
                return Results.Unauthorized();

            await documentRepository.SetAsync($"users/{userId}", request.MapToDictionary());

            return Results.Ok();
        }

        public static async Task<IResult> DeleteUser([FromServices] IDocumentDBRepository documentRepository, string userId, IStorage storage, HttpContext context) 
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? tokenUserId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(tokenUserId) || userId != tokenUserId)
                return Results.Unauthorized();

            await documentRepository.DeleteAsync($"users/{userId}");

            await storage.DeleteFileAsync("userPhotos", userId);
            return Results.Ok();
        }

        public static async Task<IResult> ChangePhoto(string userId, IFormFile file, IStorage storage, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? tokenUserId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(tokenUserId) || userId != tokenUserId)
                return Results.Unauthorized();

            await storage.UploadFileAsync("userPhotos", file.OpenReadStream(), userId);
            return Results.Ok();
        }

        public static async Task<IResult> DeletePhoto(string userId, IStorage storage, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? tokenUserId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(tokenUserId) || userId != tokenUserId)
                return Results.Unauthorized();

            await storage.DeleteFileAsync("userPhotos", userId);
            return Results.Ok();
        }
    }
}
