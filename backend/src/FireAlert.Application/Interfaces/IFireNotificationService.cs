using FireAlert.Application.DTOs;

namespace FireAlert.Application.Interfaces;

public interface IFireNotificationService
{
    Task NotifyFireReportCreatedAsync(FireReportDto report, FireStatisticsDto updatedStats);
}
