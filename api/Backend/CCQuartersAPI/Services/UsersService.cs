using CCQuartersAPI.Mappers;
using CCQuartersAPI.Requests;
using CCQuartersAPI.Responses;
using CloudStorageLibrary;
using RepositoryLibrary;

namespace CCQuartersAPI.Services
{
    public class UsersService : IUsersService
    {
        private readonly IDocumentDBRepository _documentRepository;
        private readonly IStorage _storage;

        private const string UsersCollection = "users";
        private const string UserPhotosCollection = "userPhotos";

        public UsersService(IDocumentDBRepository documentRepository, IStorage storage)
        {
            _documentRepository = documentRepository;
            _storage = storage;
        }

        public async Task<UserDTO?> GetUser(string userId)
        {
            var userDocument = await _documentRepository.GetAsync($"{UsersCollection}/{userId}");

            if (userDocument is null)
                return null;

            var user = userDocument.MapToUserDTO();

            try
            {
                user.PhotoUrl = await _storage.GetDownloadUrl(UserPhotosCollection, user.Id);
            }
            catch
            {
                user.PhotoUrl = null;
            }

            return user;
        }

        public async Task UpdateUser(string userId, UpdateUserRequest request)
        {
            var values = new Dictionary<string, string>();

            if (request.Name is not null)
                values["name"] = request.Name;
            if (request.Surname is not null)
                values["surname"] = request.Surname;
            if (request.Company is not null)
                values["company"] = request.Company;
            if (request.Email is not null)
                values["email"] = request.Email;
            if (request.PhoneNumber is not null)
                values["phoneNumber"] = request.PhoneNumber;

            await _documentRepository.SetAsync($"{UsersCollection}/{userId}", values);
        }

        public async Task DeleteUser(string userId)
        {
            await _documentRepository.DeleteAsync($"{UsersCollection}/{userId}");

            await _storage.DeleteFileAsync(UserPhotosCollection, userId);
        }

        public async Task ChangeUserPhoto(string userId, Stream fileStream)
        {
            await _storage.UploadFileAsync(UserPhotosCollection, fileStream, userId);
        }

        public async Task DeleteUserPhoto(string userId)
        {
            await _storage.DeleteFileAsync(UserPhotosCollection, userId);
        }
    }
}
