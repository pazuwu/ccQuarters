using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Model;

namespace VirtualTourAPI.Service
{
    public interface IVTService
    {
        Task<TourDTO?> GetTour(string tourId);
        Task<TourForEditDTO?> GetTourForEdit(string tourId);
        Task<TourInfoDBO[]> GetAllUserTourInfos(string userId);
        Task<string?> CreateTour(NewTourDTO newTour);
        Task UpdateTour(string tourId, TourUpdateDTO tourUpdate);
        Task DeleteTour(string tourId);
        Task<bool> HasUserPermissionToModifyTour(string tourId, string userId);

        Task<AreaDTO?> GetArea(string tourId, string areaId);
        Task<AreaPhotosInfoDTO> GetAreaPhotosInfo(string tourId, string areaId);
        Task<string> CreateArea(string tourId, NewAreaDTO area);
        Task<string> AddPhotoToArea(string tourId, string areaId);
        Task DeleteArea(string tourId, string areaId);

        Task<string> CreateScene(string tourId, NewSceneDTO scene);
        Task DeleteScene(string tourId, string sceneId);

        Task<string> CreateLink(string tourId, NewLinkDTO link);
        Task UpdateLink(string tourId, LinkDTO link);
        Task DeleteLink(string tourId, string linkId);

        Task<string?> CreateOperation(string tourId, string areaId);
    }
}
