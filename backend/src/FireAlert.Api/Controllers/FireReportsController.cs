using FireAlert.Application.DTOs;
using FireAlert.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FireAlert.Api.Controllers;

[ApiController]
[Route("api/fire-reports")]
public class FireReportsController : ControllerBase
{
    private readonly IFireReportService _fireReportService;

    public FireReportsController(IFireReportService fireReportService)
    {
        _fireReportService = fireReportService;
    }

    [HttpGet]
    public async Task<ActionResult<List<FireReportDto>>> GetAll()
    {
        var reports = await _fireReportService.GetAllReportsAsync();
        return Ok(reports);
    }

    [HttpGet("active")]
    public async Task<ActionResult<List<FireReportDto>>> GetActive()
    {
        var reports = await _fireReportService.GetActiveReportsAsync();
        return Ok(reports);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<FireReportDto>> GetById(int id)
    {
        var report = await _fireReportService.GetReportByIdAsync(id);
        if (report == null)
        {
            return NotFound(new { message = $"ID {id} olan yangın ihbarı bulunamadı." });
        }
        return Ok(report);
    }

    [HttpPost]
    public async Task<ActionResult<FireReportDto>> Create([FromBody] CreateFireReportDto dto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var created = await _fireReportService.CreateReportAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }
}
