using VirtualTourAPI.DTOModel;

namespace VirtualTourAPI.Services.Interfaces
{
    public interface IAreaService
    {
        Task<AreaDTO?> GetArea(string tourId, string areaId);
        Task<AreaPhotosInfoDTO> GetAreaPhotosInfo(string tourId, string areaId);
        Task<string> CreateArea(string tourId, NewAreaDTO area);
        Task<string> AddPhotoToArea(string tourId, string areaId);
        Task DeleteArea(string tourId, string areaId);
    }
}
