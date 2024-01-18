using RepositoryLibrary;
using VirtualTourAPI.DBOModel;
using VirtualTourAPI.DTOModel;
using VirtualTourAPI.Services.Interfaces;

namespace VirtualTourAPI.Services
{
    public class OperationService : IOperationService
    {
        private readonly IDocumentDBRepository _documentRepository;
        private readonly ILogger _logger;

        private readonly ITourService _tourService;
        private readonly IAreaService _areaService;
        private readonly IConfiguration _configuration;

        public OperationService(IDocumentDBRepository documentRepository, ILogger<OperationService> logger, 
            ITourService tourService, IAreaService areaService, IConfiguration configuration)
        {
            _documentRepository = documentRepository;
            _logger = logger;
            _tourService = tourService;
            _areaService = areaService;
            _configuration = configuration;
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

        public async Task DeleteOperation(string operationId)
        {
            var path = $"{DBCollections.Operations}/{operationId}";
            var operationSnapshot = await _documentRepository.GetAsync(path);
            var operation = operationSnapshot?.ConvertTo<VTOperationDBO>();

            if (operation is null) return;

            var tourInfo = await _tourService.GetTourInfo(operation.TourId);
            
            if (tourInfo is null) return;
            
            var area = await _areaService.GetArea(operation.TourId, operation.AreaId!);

            if (area is null) return;

            var emailSender = new OperationFinishedEmailSender(_configuration, tourInfo.Name, area.Name);
            await emailSender.Send(operation.UserEmail);

            _logger.LogInformation("Operation finished mail sent, id: {operationId}", operationId);

            await _documentRepository.DeleteAsync(path);
        }

        public async Task UpdateOperation(string operationId, VTOperationUpdateDTO operationUpdate)
        {
            var path = $"{DBCollections.Operations}/{operationId}";

            var updateDictionary = new Dictionary<string, object>();

            if (operationUpdate.Status != null)
                updateDictionary[nameof(operationUpdate.Status)] = operationUpdate.Status.ToString()!;
            if (operationUpdate.ProcessingAttempts != null)
                updateDictionary[nameof(operationUpdate.ProcessingAttempts)] = operationUpdate.ProcessingAttempts;
            if (operationUpdate.Stage != null)
                updateDictionary[nameof(operationUpdate.Stage)] = operationUpdate.Stage.ToString()!;


            await _documentRepository.SetAsync(path, updateDictionary);

            _logger.LogInformation("Operation updated, id: {operationId}", operationId);
        }
    }
}
