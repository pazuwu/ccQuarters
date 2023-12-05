using CCQuartersAPI.Responses;

namespace CCQuartersAPI.Services
{
    public interface IAlertsService
    {
        Task<AlertDTO[]> GetAlerts(string userId);
        Task<AlertDTO?> GetAlertById(string alertId);
        Task CreateAlert(AlertDTO alert, string userId);
        Task DeleteAlertById(string alertId);
        Task UpdateAlert(AlertDTO alert, string alertId);
    }
}
