using FireAlert.Application.DTOs;
using FireAlert.Application.Interfaces;
using FireAlert.Infrastructure.Hubs;
using Microsoft.AspNetCore.SignalR;

namespace FireAlert.Infrastructure.Notifications;

public class SignalRFireNotificationService : IFireNotificationService
{
    private readonly IHubContext<FireHub> _hubContext;

    public SignalRFireNotificationService(IHubContext<FireHub> hubContext)
    {
        _hubContext = hubContext;
    }

    public async Task NotifyFireReportCreatedAsync(FireReportDto report, FireStatisticsDto updatedStats)
    {
        await _hubContext.Clients.All.SendAsync("FireReportCreated", new
        {
            id = report.Id,
            reporterName = report.ReporterName,
            fireType = report.FireType,
            description = report.Description,
            latitude = report.Latitude,
            longitude = report.Longitude,
            imageUrl = report.ImageUrl,
            status = report.Status,
            createdAt = report.CreatedAt,
            stats = updatedStats
        });

        await _hubContext.Clients.All.SendAsync("StatisticsUpdated", updatedStats);
    }
}
