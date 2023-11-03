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

            return addedArea.Id;
        }

        public async Task<string?> CreateScene(string tourId, SceneDTO scene)
        {
            var collection = _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(ScenesCollection);

            var addedScene = await collection.AddAsync(scene);

            return addedScene.Id;
        }

        public async Task<string?> CreateLink(string tourId, LinkDTO link)
        {
            var collection = _firestore
                .Collection(ToursCollection)
                .Document(tourId)
                .Collection(LinksCollection);

            var addedLink = await collection.AddAsync(link);

            return addedLink.Id;
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
    }
}
