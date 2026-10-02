using FireAlert.Domain.Enums;

namespace FireAlert.Domain.Entities;

public class FireReport
{
    public int Id { get; set; }
    public string ReporterName { get; set; } = string.Empty;
    public FireType FireType { get; set; } = FireType.Other;
    public string? Description { get; set; }
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public string? ImageUrl { get; set; }
    public FireReportStatus Status { get; set; } = FireReportStatus.Reported;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }
}
