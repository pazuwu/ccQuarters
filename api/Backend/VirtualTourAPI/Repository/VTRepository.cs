using Google.Cloud.Firestore;
using Microsoft.Extensions.Options;
using VirtualTourAPI.Model;

namespace VirtualTourAPI.Repository
{
    public class VTRepository : IVTRepository
    {
        private const string ToursCollection = "tours";
        private const string AreasCollection = "areas";
        private const string ScenesCollection = "scenes";
        private const string LinksCollection = "links";
        private const string OperationsCollection = "operations";

        private readonly FirestoreDb _firestore;
        private readonly ILogger _logger;

        public VTRepository(IOptions<DocumentDBOptions> options, ILogger<VTRepository> logger)
        {
            if (string.IsNullOrWhiteSpace(options.Value.ProjectId))
                throw new Exception("DocumentDB ProjectId is empty. Check your configuration file.");

            _firestore = FirestoreDb.Create(options.Value.ProjectId);
            _logger = logger;
        }

        public async Task<string?> CreateArea(string tourId, AreaDTO area)
        {
            var collection = _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(AreasCollection);

            var addedArea = await collection.AddAsync(area);

            _logger.LogInformation("Created new area in tour: {tourId}, id: {Id}", tourId, addedArea.Id);

            return addedArea.Id;
        }

        public async Task<string?> CreateScene(string tourId, SceneDTO scene)
        {
            var collection = _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(ScenesCollection);

            var addedScene = await collection.AddAsync(scene);

            _logger.LogInformation("Created new scene in tour: {tourId}, id: {Id}", tourId, addedScene.Id);

            return addedScene.Id;
        }

        public async Task<string?> CreateLink(string tourId, LinkDTO link)
        {
            var collection = _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(LinksCollection);

            var addedLink = await collection.AddAsync(link);

            _logger.LogInformation("Created new link in tour: {tourId}, id: {Id}", tourId, addedLink.Id);

            return addedLink.Id;
        }

        public async Task AddPhotoToArea(string tourId, string areaId, string photoId)
        {
            var document = _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(AreasCollection)
                .Document(areaId);

            await document.UpdateAsync(nameof(AreaDTO.PhotoIds), FieldValue.ArrayUnion(photoId));
            _logger.LogInformation("Photo {photoId} was added to area {areaId} in tour {tourId}", photoId, areaId, tourId);
        }


        public async Task DeleteArea(string tourId, string areaId)
        {
            var document = _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(AreasCollection)
                .Document(areaId);

            await document.DeleteAsync();

            var snapshot = await _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(ScenesCollection)
                .WhereEqualTo(nameof(SceneDTO.ParentId), areaId)
                .GetSnapshotAsync();

            _logger.LogInformation("Area deleted in tour: {tourId}, id: {areaId}", tourId, areaId);

            foreach (var link in snapshot)
                await DeleteScene(tourId, link.Id);
        }

        public async Task<string?> CreateOperation(string tourId, string areaId)
        {
            var collection = _firestore.Collection(OperationsCollection);

            var operations = await collection.WhereEqualTo(nameof(VTOperationDTO.AreaId), areaId).Count().GetSnapshotAsync();

            if (operations.Count > 0)
                return null;

            var operation = new VTOperationDTO() 
            { 
                AreaId = areaId, 
                TourId = tourId 
            };

            var addedOperation = await collection.AddAsync(operation);

            _logger.LogInformation("Created new operation for tour: {tourId}, area: {areaId}", tourId, areaId);

            return addedOperation.Id;
        }


        public async Task DeleteScene(string tourId, string sceneId)
        {
            var document = _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(ScenesCollection)
                .Document(sceneId);

            await document.DeleteAsync();

            var snapshot = await _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(LinksCollection)
                .WhereEqualTo(nameof(LinkDTO.ParentId), sceneId)
                .GetSnapshotAsync();

            _logger.LogInformation("Scene deleted in tour: {tourId}, id: {sceneId}", tourId, sceneId);

            foreach (var link in snapshot)
                await DeleteLink(tourId, link.Id);
        }

        public async Task DeleteLink(string tourId, string linkId)
        {
            var document = _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(LinksCollection)
                .Document(linkId);

            await document.DeleteAsync();

            _logger.LogInformation("Link deleted in tour: {tourId}, id: {linkId}", tourId, linkId);
        }

        public async Task UpdateLink(string tourId, LinkDTO link)
        {
            var document = _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(LinksCollection)
                .Document(link.Id);

            await document.SetAsync(link, SetOptions.MergeAll);
        }

        public async Task<TourDTO?> GetTour(string tourId)
        {
            _logger.LogInformation("Get tour from documents, id: {tourId}", tourId);

            var tourDocument = _firestore
                .Collection(ToursCollection)
                .Document(tourId);

            var tourTask = tourDocument.GetSnapshotAsync();
            var areasTask = tourDocument.Collection(AreasCollection).GetSnapshotAsync();
            var scenesTask = tourDocument.Collection(ScenesCollection).GetSnapshotAsync();
            var linksTask = tourDocument.Collection(LinksCollection).GetSnapshotAsync();

            await Task.WhenAll(tourTask, areasTask, scenesTask, linksTask);

            var links = ConvertCollection<LinkDTO>(linksTask).ToList();
            var scenes = ConvertCollection<SceneDTO>(scenesTask).ToList();
            var areas = ConvertCollection<AreaDTO>(areasTask).ToList();
            var tour = tourTask.GetAwaiter().GetResult().ConvertTo<TourDTO>();

            if (tour == null)
                return null;

            tour.Areas = areas;
            tour.Scenes = scenes;
            tour.Links = links;

            return tour;
        }

        private IEnumerable<T> ConvertCollection<T>(Task<QuerySnapshot> queryTask)
        {
            return queryTask
                .GetAwaiter()
                .GetResult()
                .Documents.Select(d => d.ConvertTo<T>());
        }

        public async Task<string?> CreateTour()
        {
            var collection = _firestore.Collection(ToursCollection);
            
            var addedTour = await collection.AddAsync(new Dictionary<string,string>());

            _logger.LogInformation("Created new tour: {Id}", addedTour.Id);

            return addedTour.Id;
        }

        public async Task DeleteTour(string tourId)
        {
            var document = _firestore
                .Collection(ToursCollection)
                .Document(tourId);

            await document.DeleteAsync();

            _logger.LogInformation("Tour deleted: {tourId}", tourId);
        }
    }
}
