using Google.Cloud.Firestore;
using RepositoryLibrary;
using VirtualTourAPI.Model;

namespace VirtualTourAPI.Service
{
    public class VTService : IVTService
    {
        private const string ToursCollection = "tours";
        private const string AreasCollection = "areas";
        private const string ScenesCollection = "scenes";
        private const string LinksCollection = "links";
        private const string OperationsCollection = "operations";

        private readonly IDocumentDBRepository _documentRepository;
        private readonly ILogger _logger;

        public VTService(IDocumentDBRepository documentRepository, ILogger<VTService> logger)
        {
            _documentRepository = documentRepository;
            _logger = logger;
        }

        public async Task<AreaDTO?> GetArea(string tourId, string areaId)
        {
            string path = $"{ToursCollection}/{tourId}/{AreasCollection}/{areaId}";

            var addedArea = await _documentRepository.GetAsync(path);

            if (addedArea is null)
            {
                _logger.LogWarning("Get area from tour {tourId} returned null", tourId);
                return null;
            }

            _logger.LogInformation("Get area {Id} from tour {tourId}", tourId, addedArea.Id);

            return addedArea.ConvertTo<AreaDTO>();
        }

        public async Task<string?> CreateArea(string tourId, AreaDTO area)
        {
            string path = $"{ToursCollection}/{tourId}/{AreasCollection}";

            var addedAreaId = await _documentRepository.AddAsync(path, area);

            _logger.LogInformation("Created new area in tour: {tourId}, id: {Id}", tourId, addedAreaId);

            return addedAreaId;
        }

        public async Task<string?> CreateScene(string tourId, SceneDTO scene)
        {
            string path = $"{ToursCollection}/{tourId}/{ScenesCollection}";

            var addedSceneId = await _documentRepository.AddAsync(path, scene);

            _logger.LogInformation("Created new scene in tour: {tourId}, id: {Id}", tourId, addedSceneId);

            return addedSceneId;
        }

        public async Task<string?> CreateLink(string tourId, LinkDTO link)
        {
            string path = $"{ToursCollection}/{tourId}/{LinksCollection}";

            var addedLinkId = await _documentRepository.AddAsync(path, link);

            _logger.LogInformation("Created new link in tour: {tourId}, id: {Id}", tourId, addedLinkId);

            return addedLinkId;
        }

        public async Task AddPhotoToArea(string tourId, string areaId, string photoId)
        {
            string path = $"{ToursCollection}/{tourId}/{AreasCollection}/{areaId}";

            await _documentRepository.UpdateAsync(path, nameof(AreaDTO.PhotoIds), FieldValue.ArrayUnion(photoId));
            _logger.LogInformation("Photo {photoId} was added to area {areaId} in tour {tourId}", photoId, areaId, tourId);
        }


        public async Task DeleteArea(string tourId, string areaId)
        {
            string deletePath = $"{ToursCollection}/{tourId}/{AreasCollection}/{areaId}";

            await _documentRepository.DeleteAsync(deletePath);

            string getPath = $"{ToursCollection}/{tourId}/{ScenesCollection}";

            _logger.LogInformation("Area deleted in tour: {tourId}, id: {areaId}", tourId, areaId);

            var snapshot = await _documentRepository.GetByFieldAsync(getPath, nameof(SceneDTO.ParentId), areaId);

            if (snapshot is null)
                return;

            foreach (var link in snapshot)
                await DeleteScene(tourId, link.Id);
        }

        public async Task<string?> CreateOperation(string tourId, string areaId)
        {
            long? operationsCount = await _documentRepository.GetCountByFieldAsync(OperationsCollection, nameof(VTOperationDTO.AreaId), areaId);

            if (operationsCount is not null && operationsCount > 0)
                return null;

            var operation = new VTOperationDTO()
            {
                AreaId = areaId,
                TourId = tourId
            };

            string addedOperationId = await _documentRepository.AddAsync(OperationsCollection, operation);

            _logger.LogInformation("Created new operation for tour: {tourId}, area: {areaId}", tourId, areaId);

            string areaPath = $"{ToursCollection}/{tourId}/{AreasCollection}/{areaId}";
            await _documentRepository.UpdateAsync(areaPath, nameof(AreaDTO.OperationId), addedOperationId);

            return addedOperationId;
        }


        public async Task DeleteScene(string tourId, string sceneId)
        {
            string deletePath = $"{ToursCollection}/{tourId}/{ScenesCollection}/{sceneId}";

            await _documentRepository.DeleteAsync(deletePath);

            string getPath = $"{ToursCollection}/{tourId}/{LinksCollection}";

            var snapshot = await _documentRepository.GetByFieldAsync(getPath, nameof(LinkDTO.ParentId), sceneId);

            if(snapshot == null) return;

            _logger.LogInformation("Scene deleted in tour: {tourId}, id: {sceneId}", tourId, sceneId);

            foreach (var link in snapshot)
                await DeleteLink(tourId, link.Id);
        }

        public async Task DeleteLink(string tourId, string linkId)
        {
            string path = $"{ToursCollection}/{tourId}/{LinksCollection}/{linkId}";

            await _documentRepository.DeleteAsync(path);

            _logger.LogInformation("Link deleted in tour: {tourId}, id: {linkId}", tourId, linkId);
        }

        public async Task UpdateLink(string tourId, LinkDTO link)
        {
            string path = $"{ToursCollection}/{tourId}/{LinksCollection}/{link.Id}";

            await _documentRepository.SetAsync(path, link);

            _logger.LogInformation("Link updated in tour: {tourId}, id: {linkId}", tourId, link.Id);
        }

        public async Task<TourDTO?> GetTour(string tourId)
        {
            _logger.LogInformation("Get tour from documents, id: {tourId}", tourId);

            string tourPath = $"{ToursCollection}/{tourId}";

            var tourTask = _documentRepository.GetAsync(tourPath);
            var areasTask = _documentRepository.GetCollectionAsync($"{tourPath}/{AreasCollection}");
            var scenesTask = _documentRepository.GetCollectionAsync($"{tourPath}/{ScenesCollection}");
            var linksTask = _documentRepository.GetCollectionAsync($"{tourPath}/{LinksCollection}");

            await Task.WhenAll(tourTask, areasTask, scenesTask, linksTask);

            var links = ConvertCollection<LinkDTO>(linksTask)?.ToList();
            var scenes = ConvertCollection<SceneDTO>(scenesTask)?.ToList();
            var areas = ConvertCollection<AreaDTO>(areasTask)?.ToList();
            var tour = tourTask.GetAwaiter().GetResult()?.ConvertTo<TourDTO?>();

            if (tour == null)
                return null;

            tour.Areas = areas;
            tour.Scenes = scenes;
            tour.Links = links;

            return tour;
        }

        private IEnumerable<T>? ConvertCollection<T>(Task<IEnumerable<DocumentSnapshot>?> queryTask)
        {
            return queryTask
                .GetAwaiter()
                .GetResult()
                ?.Select(d => d.ConvertTo<T>());
        }

        public async Task<string?> CreateTour(TourDTO tour)
        {
            string addedTourId = await _documentRepository.AddAsync(ToursCollection, tour);

            _logger.LogInformation("Created new tour: {Id}", addedTourId);

            return addedTourId;
        }

        public async Task UpdateTour(string tourId, TourUpdate tourUpdate)
        {
            string path = $"{ToursCollection}/{tourId}";

            var updateDictionary = new Dictionary<string, object>();

            if(tourUpdate.Name != null)
                updateDictionary[nameof(tourUpdate.Name)] = tourUpdate.Name;
            if(tourUpdate.PrimarySceneId != null)
                updateDictionary[nameof(tourUpdate.PrimarySceneId)] = tourUpdate.PrimarySceneId;

            if(updateDictionary.Any())
            {
                string addedTourId = await _documentRepository.SetAsync(path, updateDictionary);
                _logger.LogInformation("Changed tour: {Id}", addedTourId);
            }
        }

        public async Task DeleteTour(string tourId)
        {
            string path = $"{ToursCollection}/{tourId}";

            await _documentRepository.DeleteAsync(path);

            _logger.LogInformation("Tour deleted: {tourId}", tourId);
        }

        public async Task<bool> HasUserPermissionToModifyTour(string tourId, string userId)
        {
            string tourPath = $"{ToursCollection}/{tourId}";
            var tourSnapshot = await _documentRepository.GetAsync(tourPath);
            var tourOwnerId = tourSnapshot?.GetValue<string>(new FieldPath(nameof(TourDTO.OwnerId)));

            return tourOwnerId == userId;
        }

        public async Task<TourInfoDTO[]> GetAllUserTourInfos(string userId)
        {
            var allUserToursSnapshotTask = _documentRepository.GetByFieldAsync(ToursCollection, nameof(TourDTO.OwnerId), userId);
            await allUserToursSnapshotTask;
            var allUserToursIds = ConvertCollection<TourInfoDTO>(allUserToursSnapshotTask)?.ToArray();

            return allUserToursIds ?? Array.Empty<TourInfoDTO>();
        }
    }
}
