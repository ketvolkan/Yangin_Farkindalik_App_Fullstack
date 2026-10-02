using FireAlert.Domain.Entities;
using FireAlert.Domain.Enums;

namespace FireAlert.Application.Interfaces;

public interface IFireReportRepository
{
    Task<List<FireReport>> GetAllAsync();
    Task<List<FireReport>> GetActiveAsync();
    Task<FireReport?> GetByIdAsync(int id);
    Task<FireReport> AddAsync(FireReport report);
    Task<int> GetCountAsync();
    Task<int> GetCountSinceAsync(DateTime since);
}
