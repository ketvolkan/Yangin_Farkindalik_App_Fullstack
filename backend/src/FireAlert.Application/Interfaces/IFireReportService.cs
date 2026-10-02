using FireAlert.Application.DTOs;

namespace FireAlert.Application.Interfaces;

public interface IFireReportService
{
    Task<List<FireReportDto>> GetAllReportsAsync();
    Task<List<FireReportDto>> GetActiveReportsAsync();
    Task<FireReportDto?> GetReportByIdAsync(int id);
    Task<FireReportDto> CreateReportAsync(CreateFireReportDto dto);
    Task<FireStatisticsDto> GetStatisticsAsync();
}
