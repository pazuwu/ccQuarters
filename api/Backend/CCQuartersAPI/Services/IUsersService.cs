using CCQuartersAPI.Requests;
using CCQuartersAPI.Responses;

namespace CCQuartersAPI.Services
{
    public interface IUsersService
    {
        Task<UserDTO?> GetUser(string userId);
        Task UpdateUser(string userId, UpdateUserRequest request);
        Task DeleteUser(string userId);
        Task ChangeUserPhoto(string userId, Stream fileStream);
        Task DeleteUserPhoto(string userId);
    }
}
