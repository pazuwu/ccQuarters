using VirtualTourAPI.Client.Parameters;
using VirtualTourAPI.ServiceClient.Parameters;
using VirtualTourAPI.ServiceClient.Results;

namespace VirtualTourAPI.ServiceClient
{
    public interface IVTService
    {
        Task<GetTourResult> GetTourById(GetTourParameters parameters);
        Task<CreateTourResult> CreateTour(CreateTourParameters parameters);
        Task<DeleteTourResult> DeleteTour(DeleteTourParameters parameters);

        Task<CreateAreaResult> CreateArea(CreateAreaParameters parameters);
        Task<DeleteAreaResult> DeleteArea(DeleteAreaParameters parameters);
        Task<AddPhotoToAreaResult> AddPhotoToArea(AddPhotoToAreaParameters parameters);

        Task<CreateSceneResult> CreateScene(CreateSceneParameters parameters);
        Task<DeleteSceneResult> DeleteScene(DeleteSceneParameters parameters);
        Task<AddPhotoToSceneResult> AddPhotoToScene(AddPhotoToSceneParameters parameters);

        Task<CreateLinkResult> CreateLink(CreateLinkParameters parameters);
        Task<CreateLinkResult> DeleteLink(CreateLinkParameters parameters);
        Task<UpdateLinkResult> UpdateLink(UpdateLinkParameters parameters);
    }
}
