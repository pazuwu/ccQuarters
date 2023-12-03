using CCQuartersAPI.Mappers;
using CCQuartersAPI.Responses;
using CloudStorageLibrary;
using RepositoryLibrary;

namespace CCQuartersAPI.CommonClasses
{
    public static class CommonGetters
    {
#warning TODO: move to UserService (once it will be created)
        public static async Task<UserDTO?> GetUser(this IDocumentDBRepository documentRepository, string userId, IStorage storage)
        {
            var userDocument = await documentRepository.GetAsync($"users/{userId}");

            if (userDocument is null)
                return null;

            var user = userDocument.MapToUserDTO();

            try
            {
                user.PhotoUrl = await storage.GetDownloadUrl("userPhotos", user.Id);
            }
            catch
            {
                user.PhotoUrl = null;
            }

            return user;
        }
    }
}
