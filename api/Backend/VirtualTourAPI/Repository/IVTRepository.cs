using VirtualTourAPI.Model;

namespace VirtualTourAPI.Repository
{
    public interface IVTRepository
    {
        Task<TourDTO?> GetTour(string tourId);

        Task<string?> CreateArea(string tourId, AreaDTO area);
        Task DeleteArea(string tourId, string areaId);

        Task<string?> CreateScene(string tourId, SceneDTO scene);
        Task DeleteScene(string tourId, string sceneId);

        Task<string?> CreateLink(string tourId, LinkDTO link);
        Task UpdateLink(string tourId, LinkDTO link);
        Task DeleteLink(string tourId, string linkId);
    }
}
