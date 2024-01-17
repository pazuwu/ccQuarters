using VirtualTourAPI.Client.Parameters;
using VirtualTourAPI.Client.Results;

namespace VirtualTourAPI.Client
{
    public interface IVTService
    {
        Task<GetTourResult> GetTourById(GetTourParameters parameters);
        Task<CreateTourResult> CreateTour(CreateTourParameters parameters);
        Task<DeleteTourResult> DeleteTour(DeleteTourParameters parameters);

        Task<CreateAreaResult> CreateArea(CreateAreaParameters parameters);
        Task<DeleteAreaResult> DeleteArea(DeleteAreaParameters parameters);
        Task<AddPhotoToAreaResult> AddPhotoToArea(AddPhotoToAreaParameters parameters);
        Task<GetAreaPhotosResult> GetAreaPhotos(GetAreaPhotosParameters parameters);

        Task<CreateSceneResult> CreateScene(CreateSceneParameters parameters);
        Task<DeleteSceneResult> DeleteScene(DeleteSceneParameters parameters);
        Task<AddPhotoToSceneResult> AddPhotoToScene(AddPhotoToSceneParameters parameters);

        Task<CreateLinkResult> CreateLink(CreateLinkParameters parameters);
        Task<DeleteLinkResult> DeleteLink(DeleteLinkParameters parameters);
        Task<UpdateLinkResult> UpdateLink(UpdateLinkParameters parameters);

        Task<UpdateOperationResult> UpdateOperation(UpdateOperationParameters parameters);
        Task<DeleteOperationResult> DeleteOperation(DeleteOperationParameters parameters);
    }
}
