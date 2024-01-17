using Google.Cloud.Firestore;
using RepositoryLibrary;
using VirtualTourAPI.DBOModel;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Mappers;
using VirtualTourAPI.Model;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.Services
{
    public class TourService : ITourService
    {
        private readonly IDocumentDBRepository _documentRepository;
        private readonly ILogger _logger;

        public TourService(IDocumentDBRepository documentRepository, ILogger<TourService> logger)
        {
            _documentRepository = documentRepository;
            _logger = logger;
        }

        public async Task<TourForEditDTO?> GetTourForEdit(string tourId)
        {
            _logger.LogInformation("Get tour from documents for edit, id: {tourId}", tourId);

            string tourPath = $"{DBCollections.Tours}/{tourId}";

            var tourTask = _documentRepository.GetAsync(tourPath);
            var areasTask = _documentRepository.GetCollectionAsync($"{tourPath}/{DBCollections.Areas}");
            var scenesTask = _documentRepository.GetCollectionAsync($"{tourPath}/{DBCollections.Scenes}");
            var linksTask = _documentRepository.GetCollectionAsync($"{tourPath}/{DBCollections.Links}");

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

            string tourPath = $"{DBCollections.Tours}/{tourId}";

            var tourTask = _documentRepository.GetAsync(tourPath);
            var scenesTask = _documentRepository.GetCollectionAsync($"{tourPath}/{DBCollections.Scenes}");
            var linksTask = _documentRepository.GetCollectionAsync($"{tourPath}/{DBCollections.Links}");

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

        public async Task<string?> CreateTour(NewTourDTO tour)
        {
            var tourDB = TourMapper.Map(tour);
            string addedTourId = await _documentRepository.AddAsync(DBCollections.Tours, tourDB);

            _logger.LogInformation("Created new tour: {Id}", addedTourId);

            return addedTourId;
        }

        public async Task UpdateTour(string tourId, TourUpdateDTO tourUpdate)
        {
            string path = $"{DBCollections.Tours}/{tourId}";

            var updateDictionary = new Dictionary<string, object>();

            if (tourUpdate.Name != null)
                updateDictionary[nameof(tourUpdate.Name)] = tourUpdate.Name;
            if (tourUpdate.PrimarySceneId != null)
                updateDictionary[nameof(tourUpdate.PrimarySceneId)] = tourUpdate.PrimarySceneId;

            if (updateDictionary.Any())
            {
                string addedTourId = await _documentRepository.SetAsync(path, updateDictionary);
                _logger.LogInformation("Changed tour: {Id}", addedTourId);
            }
        }

        public async Task DeleteTour(string tourId)
        {
            string path = $"{DBCollections.Tours}/{tourId}";

            await _documentRepository.DeleteAsync(path);

            _logger.LogInformation("Tour deleted: {tourId}", tourId);
        }

        public async Task<bool> HasUserPermissionToModifyTour(string tourId, string userId)
        {
            string tourPath = $"{DBCollections.Tours}/{tourId}";
            var tourSnapshot = await _documentRepository.GetAsync(tourPath);
            var tourOwnerId = tourSnapshot?.GetValue<string>(new FieldPath(nameof(TourForEditDTO.OwnerId)));

            return tourOwnerId == userId;
        }

        public async Task<TourInfoDBO[]> GetAllUserTourInfos(string userId)
        {
            var allUserToursSnapshotTask = _documentRepository.GetByFieldAsync(DBCollections.Tours, nameof(TourForEditDTO.OwnerId), userId);
            await allUserToursSnapshotTask;
            var allUserToursIds = ConvertCollection<TourInfoDBO>(allUserToursSnapshotTask)?.ToArray();

            return allUserToursIds ?? Array.Empty<TourInfoDBO>();
        }

        private IEnumerable<T>? ConvertCollection<T>(Task<IEnumerable<DocumentSnapshot>?> queryTask)
        {
            return queryTask
                .GetAwaiter()
                .GetResult()
                ?.Select(d => d.ConvertTo<T>());
        }
    }
}
