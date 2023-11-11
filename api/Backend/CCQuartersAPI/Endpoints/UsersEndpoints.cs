using AuthLibrary;
using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.Mappers;
using CCQuartersAPI.Requests;
using CloudStorageLibrary;
using Google.Cloud.Firestore;
using System.Security.Claims;

namespace CCQuartersAPI.Endpoints
{
    public class UsersEndpoints
    {

        public static async Task<IResult> GetUser(string userId, IStorage storage) 
        {
            FirestoreDb firestoreDb = FirestoreDb.Create("ccquartersmini");

            var user = await firestoreDb.GetUser(userId, storage);

            if (user is null)
                return Results.NotFound("User does not exist.");

            return Results.Ok(user);
        }
        public static async Task<IResult> UpdateUser(string userId, UpdateUserRequest request, HttpContext context)
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? tokenUserId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(tokenUserId) || tokenUserId != userId)
                return Results.Unauthorized();

            FirestoreDb firestoreDb = FirestoreDb.Create("ccquartersmini");

            DocumentReference userRef = firestoreDb.Collection("users").Document(userId);
            await userRef.SetAsync(request.MapToDictionary(), SetOptions.MergeAll);

            return Results.Ok();
        }

        public static async Task<IResult> DeleteUser(string userId, IStorage storage, HttpContext context) 
        {
            var identity = context.User.Identity as ClaimsIdentity;
            string? tokenUserId = identity?.GetUserId();
            if (string.IsNullOrWhiteSpace(tokenUserId) || userId != tokenUserId)
                return Results.Unauthorized();

            FirestoreDb firestoreDb = FirestoreDb.Create("ccquartersmini");

            DocumentReference userRef = firestoreDb.Collection("users").Document(userId);
            await userRef.DeleteAsync();

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
