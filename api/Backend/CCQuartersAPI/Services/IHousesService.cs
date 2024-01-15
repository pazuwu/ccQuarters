using CCQuartersAPI.CommonClasses;
using CCQuartersAPI.Requests;
using CCQuartersAPI.Responses;
using System.Data;

namespace CCQuartersAPI.Services
{
    public interface IHousesService
    {
        Task<BasicHouseInfoDTO?> GetBasicHouseInfo(Guid houseId);
        Task<IEnumerable<SimpleHouseDTO>?> GetSimpleHousesInfo(GetHousesQuery housesQuery, string userId, int pageNumber, int pageSize);
        Task<IEnumerable<SimpleHouseDTO>?> GetSimpleHousesInfoCreatedByUser(string userId, int pageNumber, int pageSize);
        Task<IEnumerable<SimpleHouseDTO>?> GetSimpleHousesInfoLikedByUser(string userId, int pageNumber, int pageSize);
        Task<DetailedHouseDTO?> GetDetailedHouseInfo(Guid houseId, string userId);
        Task<Guid> CreateHouse(string userId, CreateHouseRequest houseRequest);
        Task UpdateHouse(Guid houseId, CreateHouseRequest houseRequest, DetailedHouseDTO houseQueried);
        Task DeleteHouse(Guid houseId);
        Task LikeHouse(string userId, Guid houseId);
        Task UnlikeHouse(string userId, Guid houseId);
    }
}
