using RepositoryLibrary;
using System.Collections.Immutable;
using VirtualTourAPI.DBOModel;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Mappers;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.Services
{
    public class AreaService : IAreaService
    {
        private readonly IDocumentDBRepository _documentRepository;
        private readonly ILogger _logger;

        public AreaService(IDocumentDBRepository documentRepository, ILogger<AreaService> logger)
        {
            _documentRepository = documentRepository;
            _logger = logger;
        }

        public async Task<AreaDTO?> GetArea(string tourId, string areaId)
        {
            string path = $"{DBCollections.Tours}/{tourId}/{DBCollections.Areas}/{areaId}";

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
            string path = $"{DBCollections.Tours}/{tourId}/{DBCollections.Areas}/{areaId}/photos";

            var areaPhotosSnapshot = await _documentRepository.GetCollectionAsync(path);

            _logger.LogInformation("Get area {areaId} photos from tour {tourId}", areaId, tourId);

            var areaPhotos = areaPhotosSnapshot?.Select(p => p.Id).ToArray();

            return new AreaPhotosInfoDTO
            {
                PhotoIds = areaPhotos ?? Array.Empty<string>(),
            };
        }

        public async Task<string> CreateArea(string tourId, NewAreaDTO area)
        {
            string path = $"{DBCollections.Tours}/{tourId}/{DBCollections.Areas}";

            var newAreaDB = AreaMapper.Map(area);
            var addedAreaId = await _documentRepository.AddAsync(path, newAreaDB);

            _logger.LogInformation("Created new area in tour: {tourId}, id: {Id}", tourId, addedAreaId);

            return addedAreaId;
        }

        public async Task<string> AddPhotoToArea(string tourId, string areaId)
        {
            string path = $"{DBCollections.Tours}/{tourId}/{DBCollections.Areas}/{areaId}/photos";

            var photoId = await _documentRepository.AddAsync(path, ImmutableDictionary<string, string>.Empty);
            _logger.LogInformation("Photo {photoId} was added to area {areaId} in tour {tourId}", photoId, areaId, tourId);
            return photoId;
        }


        public async Task DeleteArea(string tourId, string areaId)
        {
            string deletePath = $"{DBCollections.Tours}/{tourId}/{DBCollections.Areas}/{areaId}";

            await _documentRepository.DeleteAsync(deletePath);
        }
    }
}
