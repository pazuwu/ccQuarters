using CCQuartersAPI.AlertsDTOs;
using System.Data;

namespace CCQuartersAPI.Services
{
    public interface IAlertsService
    {
        Task<AlertDTO[]> GetAlerts(string userId, int pageNumber, int pageSize);
        Task<AlertDTO?> GetAlertById(Guid alertId);
        Task<Guid?> CreateAlert(CreateAlertRequest alert, string userId);
        Task DeleteAlertById(Guid alertId);
        Task UpdateAlert(UpdateAlertRequest alert, Guid alertId);
        Task<string[]> GetUserIdsWithAlertsMatchingWithHouse(Guid houseId);
        Task SendAlertEmails(IEnumerable<string> emails, Guid houseId);
    }
}
