using FireAlert.Application.DTOs;
using FireAlert.Application.Interfaces;
using FireAlert.Application.Services;
using FireAlert.Domain.Entities;
using FireAlert.Domain.Enums;
using FireAlert.Infrastructure.Data;
using FireAlert.Infrastructure.Repositories;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace FireAlert.UnitTests;

public class FireReportServiceTests
{
    private FireAlertDbContext CreateInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<FireAlertDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;
        return new FireAlertDbContext(options);
    }

    [Fact]
    public async Task CreateReportAsync_ShouldSaveReportAndNotify()
    {
        // Arrange
        using var dbContext = CreateInMemoryDbContext();
        var repository = new FireReportRepository(dbContext);
        var mockNotification = new Mock<IFireNotificationService>();
        var service = new FireReportService(repository, mockNotification.Object);

        var dto = new CreateFireReportDto
        {
            ReporterName = "Volkan Ket",
            FireType = "Forest",
            Description = "Duman ve alev görülüyor.",
            Latitude = 37.8636,
            Longitude = 27.2619,
            ImageUrl = null
        };

        // Act
        var result = await service.CreateReportAsync(dto);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Volkan Ket", result.ReporterName);
        Assert.Equal("Forest", result.FireType);
        Assert.Equal(37.8636, result.Latitude);
        Assert.Equal(27.2619, result.Longitude);
        Assert.Equal("Reported", result.Status);

        // Verify DB persistence
        var count = await dbContext.FireReports.CountAsync();
        Assert.Equal(1, count);

        // Verify SignalR notification was invoked
        mockNotification.Verify(
            n => n.NotifyFireReportCreatedAsync(It.IsAny<FireReportDto>(), It.IsAny<FireStatisticsDto>()),
            Times.Once);
    }

    [Fact]
    public async Task GetActiveReportsAsync_ShouldOnlyReturnReportedAndReviewed()
    {
        // Arrange
        using var dbContext = CreateInMemoryDbContext();
        var repository = new FireReportRepository(dbContext);
        var mockNotification = new Mock<IFireNotificationService>();
        var service = new FireReportService(repository, mockNotification.Object);

        dbContext.FireReports.AddRange(
            new FireReport { ReporterName = "A", FireType = FireType.Forest, Latitude = 1, Longitude = 1, Status = FireReportStatus.Reported, CreatedAt = DateTime.UtcNow },
            new FireReport { ReporterName = "B", FireType = FireType.Building, Latitude = 2, Longitude = 2, Status = FireReportStatus.Reviewed, CreatedAt = DateTime.UtcNow },
            new FireReport { ReporterName = "C", FireType = FireType.Vehicle, Latitude = 3, Longitude = 3, Status = FireReportStatus.Resolved, CreatedAt = DateTime.UtcNow }
        );
        await dbContext.SaveChangesAsync();

        // Act
        var activeReports = await service.GetActiveReportsAsync();

        // Assert
        Assert.Equal(2, activeReports.Count);
        Assert.DoesNotContain(activeReports, r => r.Status == "Resolved");
    }

    [Fact]
    public async Task GetStatisticsAsync_ShouldCalculateCorrectly()
    {
        // Arrange
        using var dbContext = CreateInMemoryDbContext();
        var repository = new FireReportRepository(dbContext);
        var mockNotification = new Mock<IFireNotificationService>();
        var service = new FireReportService(repository, mockNotification.Object);

        var now = DateTime.UtcNow;
        dbContext.FireReports.AddRange(
            new FireReport { ReporterName = "A", FireType = FireType.Forest, Latitude = 1, Longitude = 1, CreatedAt = now },
            new FireReport { ReporterName = "B", FireType = FireType.Building, Latitude = 2, Longitude = 2, CreatedAt = now.AddMinutes(-30) },
            new FireReport { ReporterName = "C", FireType = FireType.Vehicle, Latitude = 3, Longitude = 3, CreatedAt = now.AddMinutes(-60) }
        );
        await dbContext.SaveChangesAsync();

        // Act
        var stats = await service.GetStatisticsAsync();

        // Assert
        Assert.Equal(3, stats.Total);
        Assert.Equal(3, stats.Today);
        Assert.Equal(3, stats.ThisWeek);
        Assert.Equal(3, stats.ThisMonth);
    }
}
