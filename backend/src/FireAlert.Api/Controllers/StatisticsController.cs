using FireAlert.Application.DTOs;
using FireAlert.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FireAlert.Api.Controllers;

[ApiController]
[Route("api/statistics")]
public class StatisticsController : ControllerBase
{
    private readonly IFireReportService _fireReportService;

    public StatisticsController(IFireReportService fireReportService)
    {
        _fireReportService = fireReportService;
    }

    [HttpGet]
    public async Task<ActionResult<FireStatisticsDto>> GetStatistics()
    {
        var stats = await _fireReportService.GetStatisticsAsync();
        return Ok(stats);
    }
}
