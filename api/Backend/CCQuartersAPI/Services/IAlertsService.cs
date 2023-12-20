using CCQuartersAPI.AlertsDTOs;
using System.Data;

namespace CCQuartersAPI.Services
{
    public interface IAlertsService
    {
        Task<AlertDTO[]> GetAlerts(string userId, int pageNumber, int pageSize, IDbTransaction? trans = null);
        Task<AlertDTO?> GetAlertById(Guid alertId, IDbTransaction? trans = null);
        Task<Guid?> CreateAlert(CreateAlertRequest alert, string userId, IDbTransaction? trans = null);
        Task DeleteAlertById(Guid alertId, IDbTransaction? trans = null);
        Task UpdateAlert(UpdateAlertRequest alert, Guid alertId, IDbTransaction? trans = null);
    }
}
