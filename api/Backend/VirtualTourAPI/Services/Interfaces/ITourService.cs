using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Model;

namespace VirtualTourAPI.Services.Interfaces
{
    public interface ITourService
    {
        Task<TourDTO?> GetTour(string tourId);
        Task<TourForEditDTO?> GetTourForEdit(string tourId);
        Task<TourInfoDTO[]> GetAllUserTourInfos(string userId);
        Task<TourInfoDTO?> GetTourInfo(string tourId);
        Task<string?> CreateTour(NewTourDTO newTour);
        Task UpdateTour(string tourId, TourUpdateDTO tourUpdate);
        Task DeleteTour(string tourId);
        Task<bool> HasUserPermissionToModifyTour(string tourId, string userId);
    }
}
