using Google.Cloud.Firestore;
using RepositoryLibrary;
using System.IO;
using VirtualTourAPI.DBOModel;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Mappers;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.Services
{
    public class SceneService : ISceneService
    {
        private readonly IDocumentDBRepository _documentRepository;
        private readonly ILogger _logger;

        public SceneService(IDocumentDBRepository documentRepository, ILogger<SceneService> logger)
        {
            _documentRepository = documentRepository;
            _logger = logger;
        }

        public async Task<string> CreateScene(string tourId, NewSceneDTO scene)
        {
            string path = $"{DBCollections.Tours}/{tourId}/{DBCollections.Scenes}";

            var newSceneDB = SceneMapper.Map(scene);
            string addedSceneId = await _documentRepository.AddAsync(path, newSceneDB);

            _logger.LogInformation("Created new scene in tour: {tourId}, id: {Id}", tourId, addedSceneId);

            return addedSceneId;
        }

        public async Task DeleteScene(string tourId, string sceneId)
        {
            string deletePath = $"{DBCollections.Tours}/{tourId}/{DBCollections.Scenes}/{sceneId}";

            await _documentRepository.DeleteAsync(deletePath);

            _logger.LogInformation("Scene deleted in tour: {tourId}, id: {sceneId}", tourId, sceneId);
            
            string getPath = $"{DBCollections.Tours}/{tourId}/{DBCollections.Links}";

            var parentLinks = await _documentRepository.GetByFieldAsync(getPath, nameof(LinkDTO.ParentId), sceneId);
            var destinationLinks = await _documentRepository.GetByFieldAsync(getPath, nameof(LinkDTO.DestinationId), sceneId);

            var linksConnectedToScene = Enumerable.Empty<DocumentSnapshot>()
                .Concat(parentLinks ?? Enumerable.Empty<DocumentSnapshot>())
                .Concat(destinationLinks ?? Enumerable.Empty<DocumentSnapshot>());

            foreach (var link in linksConnectedToScene)
                await _documentRepository.DeleteAsync($"{DBCollections.Tours}/{tourId}/{DBCollections.Links}/{link.Id}");

            _logger.LogInformation("All scene links deleted in tour: {tourId}, id: {sceneId}", tourId, sceneId);
        }

        public async Task UpdateScene(string tourId, string sceneId, SceneUpdateDTO sceneUpdate)
        {
            string updatePath = $"{DBCollections.Tours}/{tourId}/{DBCollections.Scenes}/{sceneId}";

            var updateDictionary = new Dictionary<string, object>();

            if (sceneUpdate.Name != null)
                updateDictionary[nameof(SceneDBO.Name)] = sceneUpdate.Name;

            if (updateDictionary.Any())
            {
                await _documentRepository.SetAsync(updatePath, updateDictionary);
                _logger.LogInformation("Changed scene {sceneId} in tour {tourId}", sceneId, tourId);
            }
        }
    }
}
