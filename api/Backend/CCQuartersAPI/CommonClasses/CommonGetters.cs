using CCQuartersAPI.Mappers;
using CCQuartersAPI.Responses;
using CloudStorageLibrary;
using Google.Cloud.Firestore;

namespace CCQuartersAPI.CommonClasses
{
    public static class CommonGetters
    {
        public static async Task<UserDTO?> GetUser(this FirestoreDb firestoreDb, string userId, IStorage storage)
        {
            DocumentReference userRef = firestoreDb.Collection("users").Document(userId);
            DocumentSnapshot userSnapshot = await userRef.GetSnapshotAsync();
            if (!userSnapshot.Exists)
                return null;

            var user = userSnapshot.MapToUserDTO();

            try
            {
                user.PhotoUrl = (await storage.GetDownloadUrl("userPhotos", user.Id)).FirstOrDefault();
            }
            catch
            {
                user.PhotoUrl = null;
            }

            return user;
        }
    }
}
