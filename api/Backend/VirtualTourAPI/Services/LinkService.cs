using RepositoryLibrary;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Mappers;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.Services
{
    public class LinkService : ILinkService
    {
        private readonly IDocumentDBRepository _documentRepository;
        private readonly ILogger _logger;

        public LinkService(IDocumentDBRepository documentRepository, ILogger<LinkService> logger)
        {
            _documentRepository = documentRepository;
            _logger = logger;
        }

        public async Task<string> CreateLink(string tourId, NewLinkDTO link)
        {
            string path = $"{DBCollections.Tours}/{tourId}/{DBCollections.Links}";

            var newLinkDB = LinkMapper.Map(link);
            var addedLinkId = await _documentRepository.AddAsync(path, newLinkDB);

            _logger.LogInformation("Created new link in tour: {tourId}, id: {Id}", tourId, addedLinkId);

            return addedLinkId;
        }

        public async Task DeleteLink(string tourId, string linkId)
        {
            string path = $"{DBCollections.Tours}/{tourId}/{DBCollections.Links}/{linkId}";

            await _documentRepository.DeleteAsync(path);

            _logger.LogInformation("Link deleted in tour: {tourId}, id: {linkId}", tourId, linkId);
        }

        public async Task UpdateLink(string tourId, LinkDTO link)
        {
            string path = $"{DBCollections.Tours}/{tourId}/{DBCollections.Links}/{link.Id}";

            var updateDictionary = new Dictionary<string, object>();

            if (link.Text != null)
                updateDictionary[nameof(link.Text)] = link.Text;
            if (link.DestinationId != null)
                updateDictionary[nameof(link.DestinationId)] = link.DestinationId;
            if (link.ParentId != null)
                updateDictionary[nameof(link.ParentId)] = link.ParentId;
            if (link.Position != null)
                updateDictionary[nameof(link.Position)] = link.Position.MapToDBGeoPoint()!;
            if (link.NextOrientation != null)
                updateDictionary[nameof(link.NextOrientation)] = link.NextOrientation.MapToDBGeoPoint()!;

            await _documentRepository.SetAsync(path, updateDictionary);

            _logger.LogInformation("Link updated in tour: {tourId}, id: {linkId}", tourId, link.Id);
        }
    }
}
