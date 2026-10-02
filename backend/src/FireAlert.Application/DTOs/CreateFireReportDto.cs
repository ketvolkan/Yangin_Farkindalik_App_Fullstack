using System.ComponentModel.DataAnnotations;

namespace FireAlert.Application.DTOs;

public class CreateFireReportDto
{
    [Required(ErrorMessage = "Bildiren kişi adı zorunludur.")]
    [MinLength(3, ErrorMessage = "Ad Soyad en az 3 karakter olmalıdır.")]
    public string ReporterName { get; set; } = string.Empty;

    [Required(ErrorMessage = "Yangın türü zorunludur.")]
    public string FireType { get; set; } = "Other";

    public string? Description { get; set; }

    [Required(ErrorMessage = "Enlem (Latitude) zorunludur.")]
    [Range(-90.0, 90.0, ErrorMessage = "Geçersiz enlem değeri.")]
    public double Latitude { get; set; }

    [Required(ErrorMessage = "Boylam (Longitude) zorunludur.")]
    [Range(-180.0, 180.0, ErrorMessage = "Geçersiz boylam değeri.")]
    public double Longitude { get; set; }

    public string? ImageUrl { get; set; }
}
