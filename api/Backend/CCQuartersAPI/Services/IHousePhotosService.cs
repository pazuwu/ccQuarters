using CCQuartersAPI.Responses;

namespace CCQuartersAPI.Services
{
    public interface IHousePhotosService
    {
        Task<IEnumerable<PhotoDTO>> GetPhotosForHouse(Guid houseId);
        Task AddHousePhoto(Guid houseId, Stream fileStream);
        Task<IEnumerable<HousePhotoQueried>> GetPhotosInfoByNames(IEnumerable<string> filenames);
        Task DeletePhotosByNames(IEnumerable<string> filenames);
    }
}
