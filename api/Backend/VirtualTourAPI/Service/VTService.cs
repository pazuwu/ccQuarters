using Google.Cloud.Firestore;
using RepositoryLibrary;
using System.Collections.Immutable;
using VirtualTourAPI.DBOModel;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Mappers;
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

            var areaDB = addedArea.ConvertTo<AreaDBO>();

            return areaDB == null 
                ? null 
                : AreaMapper.Map(areaDB);
        }

        public async Task<AreaPhotosInfoDTO> GetAreaPhotosInfo(string tourId, string areaId)
        {
            string path = $"{ToursCollection}/{tourId}/{AreasCollection}/{areaId}/photos";

            var areaPhotosTask = _documentRepository.GetCollectionAsync(path);

            _logger.LogInformation("Get area {areaId} photos from tour {tourId}", areaId, tourId);

            await areaPhotosTask;
            var areaPhotos = ConvertCollection<AreaPhotoDBO>(areaPhotosTask)?.Select(p => p.Id).ToArray();

            return new AreaPhotosInfoDTO
            {
                PhotoIds = areaPhotos ?? Array.Empty<string>(),
            };
        }

        public async Task<string> CreateArea(string tourId, NewAreaDTO area)
        {
            string path = $"{ToursCollection}/{tourId}/{AreasCollection}";

            var newAreaDB = AreaMapper.Map(area);
            var addedAreaId = await _documentRepository.AddAsync(path, newAreaDB);

            _logger.LogInformation("Created new area in tour: {tourId}, id: {Id}", tourId, addedAreaId);

            return addedAreaId;
        }

        public async Task<string> CreateScene(string tourId, NewSceneDTO scene)
        {
            string path = $"{ToursCollection}/{tourId}/{ScenesCollection}";

            var newSceneDB = SceneMapper.Map(scene);
            string addedSceneId = await _documentRepository.AddAsync(path, newSceneDB);

            _logger.LogInformation("Created new scene in tour: {tourId}, id: {Id}", tourId, addedSceneId);

            return addedSceneId;
        }

        public async Task<string> CreateLink(string tourId, NewLinkDTO link)
        {
            string path = $"{ToursCollection}/{tourId}/{LinksCollection}";

            var newLinkDB = LinkMapper.Map(link);
            var addedLinkId = await _documentRepository.AddAsync(path, newLinkDB);

            _logger.LogInformation("Created new link in tour: {tourId}, id: {Id}", tourId, addedLinkId);

            return addedLinkId;
        }

        public async Task<string> AddPhotoToArea(string tourId, string areaId)
        {
            string path = $"{ToursCollection}/{tourId}/{AreasCollection}/{areaId}/photos";

            var photoId = await _documentRepository.AddAsync(path, ImmutableDictionary<string, string>.Empty);
            _logger.LogInformation("Photo {photoId} was added to area {areaId} in tour {tourId}", photoId, areaId, tourId);
            return photoId;
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

            var updateDictionary = new Dictionary<string, object>();

            if (link.Text != null)
                updateDictionary[nameof(link.Text)] = link.Text;
            if (link.DestinationId != null)
                updateDictionary[nameof(link.DestinationId)] = link.DestinationId;
            if (link.ParentId != null)
                updateDictionary[nameof(link.ParentId)] = link.ParentId;
            if (link.Position != null)
                updateDictionary[nameof(link.Position)] = link.Position.MapToDBGeoPoint()!;
            if(link.NextOrientation != null)
                updateDictionary[nameof(link.NextOrientation)] = link.NextOrientation.MapToDBGeoPoint()!;

            await _documentRepository.SetAsync(path, updateDictionary);

            _logger.LogInformation("Link updated in tour: {tourId}, id: {linkId}", tourId, link.Id);
        }

        public async Task<TourForEditDTO?> GetTourForEdit(string tourId)
        {
            _logger.LogInformation("Get tour from documents for edit, id: {tourId}", tourId);

            string tourPath = $"{ToursCollection}/{tourId}";

            var tourTask = _documentRepository.GetAsync(tourPath);
            var areasTask = _documentRepository.GetCollectionAsync($"{tourPath}/{AreasCollection}");
            var scenesTask = _documentRepository.GetCollectionAsync($"{tourPath}/{ScenesCollection}");
            var linksTask = _documentRepository.GetCollectionAsync($"{tourPath}/{LinksCollection}");

            await Task.WhenAll(tourTask, areasTask, scenesTask, linksTask);

            var links = ConvertCollection<LinkDBO>(linksTask)?.Select(LinkMapper.Map).ToList();
            var scenes = ConvertCollection<SceneDBO>(scenesTask)?.Select(SceneMapper.Map).ToList();
            var areas = ConvertCollection<AreaDBO>(areasTask)?.Select(AreaMapper.Map).ToList();
            var tourDB = tourTask.GetAwaiter().GetResult()?.ConvertTo<TourDBO?>();

            if (tourDB == null)
                return null;

            var tour = new TourForEditDTO
            {
                Id = tourDB.Id,
                Name = tourDB.Name,
                OwnerId = tourDB.OwnerId,
                PrimarySceneId = tourDB.PrimarySceneId,
                Areas = areas,
                Links = links,
                Scenes = scenes,
            };

            return tour;
        }

        public async Task<TourDTO?> GetTour(string tourId)
        {
            _logger.LogInformation("Get tour from documents, id: {tourId}", tourId);

            string tourPath = $"{ToursCollection}/{tourId}";

            var tourTask = _documentRepository.GetAsync(tourPath);
            var scenesTask = _documentRepository.GetCollectionAsync($"{tourPath}/{ScenesCollection}");
            var linksTask = _documentRepository.GetCollectionAsync($"{tourPath}/{LinksCollection}");

            await Task.WhenAll(tourTask, scenesTask, linksTask);

            var links = ConvertCollection<LinkDBO>(linksTask)?.Select(LinkMapper.Map).ToList();
            var scenes = ConvertCollection<SceneDBO>(scenesTask)?.Select(SceneMapper.Map).ToList();
            var tourDB = tourTask.GetAwaiter().GetResult()?.ConvertTo<TourDBO?>();

            if (tourDB == null)
                return null;

            var tour = new TourDTO
            {
                Id = tourDB.Id,
                Name = tourDB.Name,
                OwnerId = tourDB.OwnerId,
                PrimarySceneId = tourDB.PrimarySceneId,
                Links = links,
                Scenes = scenes,
            };

            return tour;
        }

        private IEnumerable<T>? ConvertCollection<T>(Task<IEnumerable<DocumentSnapshot>?> queryTask)
        {
            return queryTask
                .GetAwaiter()
                .GetResult()
                ?.Select(d => d.ConvertTo<T>());
        }

        public async Task<string?> CreateTour(NewTourDTO tour)
        {
            var tourDB = TourMapper.Map(tour);
            string addedTourId = await _documentRepository.AddAsync(ToursCollection, tourDB);

            _logger.LogInformation("Created new tour: {Id}", addedTourId);

            return addedTourId;
        }

        public async Task UpdateTour(string tourId, TourUpdateDTO tourUpdate)
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
            var tourOwnerId = tourSnapshot?.GetValue<string>(new FieldPath(nameof(TourForEditDTO.OwnerId)));

            return tourOwnerId == userId;
        }

        public async Task<TourInfoDBO[]> GetAllUserTourInfos(string userId)
        {
            var allUserToursSnapshotTask = _documentRepository.GetByFieldAsync(ToursCollection, nameof(TourForEditDTO.OwnerId), userId);
            await allUserToursSnapshotTask;
            var allUserToursIds = ConvertCollection<TourInfoDBO>(allUserToursSnapshotTask)?.ToArray();

            return allUserToursIds ?? Array.Empty<TourInfoDBO>();
        }
    }
}
