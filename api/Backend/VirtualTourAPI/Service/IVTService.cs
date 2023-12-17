using VirtualTourAPI.Model;

namespace VirtualTourAPI.Service
{
    public interface IVTService
    {
        Task<TourDTO?> GetTour(string tourId);
        Task<TourInfoDTO[]> GetAllUserTourInfos(string userId);
        Task<string?> CreateTour(TourDTO tourInfo);
        Task DeleteTour(string tourId);
        Task<bool> HasUserPermissionToModifyTour(string tourId, string userId);

        Task<AreaDTO?> GetArea(string tourId, string areaId);
        Task<string?> CreateArea(string tourId, AreaDTO area);
        Task AddPhotoToArea(string tourId, string areaId, string photoId);
        Task DeleteArea(string tourId, string areaId);

        Task<string?> CreateScene(string tourId, SceneDTO scene);
        Task DeleteScene(string tourId, string sceneId);

        Task<string?> CreateLink(string tourId, LinkDTO link);
        Task UpdateLink(string tourId, LinkDTO link);
        Task DeleteLink(string tourId, string linkId);

        Task<string?> CreateOperation(string tourId, string areaId);
    }
}
