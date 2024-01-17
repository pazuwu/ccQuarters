using RepositoryLibrary;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.Services
{
    public class OperationService : IOperationService
    {
        private readonly IDocumentDBRepository _documentRepository;
        private readonly ILogger _logger;

        public OperationService(IDocumentDBRepository documentRepository, ILogger<OperationService> logger)
        {
            _documentRepository = documentRepository;
            _logger = logger;
        }

        public async Task<string?> CreateOperation(string tourId, string areaId)
        {
            long? operationsCount = await _documentRepository.GetCountByFieldAsync(DBCollections.Operations, nameof(VTOperationDTO.AreaId), areaId);

            if (operationsCount is not null && operationsCount > 0)
                return null;

            var operation = new VTOperationDTO()
            {
                AreaId = areaId,
                TourId = tourId
            };

            string addedOperationId = await _documentRepository.AddAsync(DBCollections.Operations, operation);

            _logger.LogInformation("Created new operation for tour: {tourId}, area: {areaId}", tourId, areaId);

            string areaPath = $"{DBCollections.Tours}/{tourId}/{DBCollections.Areas}/{areaId}";
            await _documentRepository.UpdateAsync(areaPath, nameof(AreaDTO.OperationId), addedOperationId);

            return addedOperationId;
        }

        public Task UpdateOperation(string tourId, VTOperationUpdateDTO operationUpdate)
        {
            throw new NotImplementedException();
        }
    }
}
