using FireAlert.Application.DTOs;
using FireAlert.Application.Interfaces;
using FireAlert.Domain.Entities;
using FireAlert.Domain.Enums;

namespace FireAlert.Application.Services;

public class FireReportService : IFireReportService
{
    private readonly IFireReportRepository _repository;
    private readonly IFireNotificationService _notificationService;

    public FireReportService(IFireReportRepository repository, IFireNotificationService notificationService)
    {
        _repository = repository;
        _notificationService = notificationService;
    }

    public async Task<List<FireReportDto>> GetAllReportsAsync()
    {
        var reports = await _repository.GetAllAsync();
        return reports.Select(MapToDto).ToList();
    }

    public async Task<List<FireReportDto>> GetActiveReportsAsync()
    {
        var reports = await _repository.GetActiveAsync();
        return reports.Select(MapToDto).ToList();
    }

    public async Task<FireReportDto?> GetReportByIdAsync(int id)
    {
        var report = await _repository.GetByIdAsync(id);
        return report == null ? null : MapToDto(report);
    }

    public async Task<FireReportDto> CreateReportAsync(CreateFireReportDto dto)
    {
        if (!Enum.TryParse<FireType>(dto.FireType, true, out var fireType))
        {
            fireType = FireType.Other;
        }

        var report = new FireReport
        {
            ReporterName = dto.ReporterName.Trim(),
            FireType = fireType,
            Description = dto.Description?.Trim(),
            Latitude = dto.Latitude,
            Longitude = dto.Longitude,
            ImageUrl = dto.ImageUrl?.Trim(),
            Status = FireReportStatus.Reported,
            CreatedAt = DateTime.UtcNow
        };

        var saved = await _repository.AddAsync(report);
        var reportDto = MapToDto(saved);
        var stats = await GetStatisticsAsync();

        try
        {
            await _notificationService.NotifyFireReportCreatedAsync(reportDto, stats);
        }
        catch
        {
            // Non-blocking notification
        }

        return reportDto;
    }

    public async Task<FireStatisticsDto> GetStatisticsAsync()
    {
        var nowUtc = DateTime.UtcNow;
        var startOfToday = new DateTime(nowUtc.Year, nowUtc.Month, nowUtc.Day, 0, 0, 0, DateTimeKind.Utc);
        
        int diff = (7 + (nowUtc.DayOfWeek - DayOfWeek.Monday)) % 7;
        var startOfWeek = startOfToday.AddDays(-1 * diff);
        var startOfMonth = new DateTime(nowUtc.Year, nowUtc.Month, 1, 0, 0, 0, DateTimeKind.Utc);

        var total = await _repository.GetCountAsync();
        var today = await _repository.GetCountSinceAsync(startOfToday);
        var thisWeek = await _repository.GetCountSinceAsync(startOfWeek);
        var thisMonth = await _repository.GetCountSinceAsync(startOfMonth);

        return new FireStatisticsDto
        {
            Today = today,
            ThisWeek = thisWeek,
            ThisMonth = thisMonth,
            Total = total
        };
    }

    private static FireReportDto MapToDto(FireReport report)
    {
        return new FireReportDto
        {
            Id = report.Id,
            ReporterName = report.ReporterName,
            FireType = report.FireType.ToString(),
            Description = report.Description,
            Latitude = report.Latitude,
            Longitude = report.Longitude,
            ImageUrl = report.ImageUrl,
            Status = report.Status.ToString(),
            CreatedAt = report.CreatedAt,
            UpdatedAt = report.UpdatedAt
        };
    }
}
