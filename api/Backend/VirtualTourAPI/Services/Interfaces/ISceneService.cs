using VirtualTourAPI.DTOModel;

namespace VirtualTourAPI.Services.Interfaces
{
    public interface ISceneService
    {
        Task<string> CreateScene(string tourId, NewSceneDTO scene);
        Task DeleteScene(string tourId, string sceneId);
    }
}
