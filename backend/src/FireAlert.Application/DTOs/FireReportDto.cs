namespace FireAlert.Application.DTOs;

public class FireReportDto
{
    public int Id { get; set; }
    public string ReporterName { get; set; } = string.Empty;
    public string FireType { get; set; } = string.Empty;
    public string? Description { get; set; }
    public double Latitude { get; set; }
    public double Longitude { get; set; }
    public string? ImageUrl { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}
