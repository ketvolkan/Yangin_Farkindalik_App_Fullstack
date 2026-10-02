using FireAlert.Application.Interfaces;
using FireAlert.Domain.Entities;
using FireAlert.Domain.Enums;
using FireAlert.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace FireAlert.Infrastructure.Repositories;

public class FireReportRepository : IFireReportRepository
{
    private readonly FireAlertDbContext _context;

    public FireReportRepository(FireAlertDbContext context)
    {
        _context = context;
    }

    public async Task<List<FireReport>> GetAllAsync()
    {
        return await _context.FireReports
            .AsNoTracking()
            .OrderByDescending(r => r.CreatedAt)
            .ToListAsync();
    }

    public async Task<List<FireReport>> GetActiveAsync()
    {
        return await _context.FireReports
            .AsNoTracking()
            .Where(r => r.Status == FireReportStatus.Reported || r.Status == FireReportStatus.Reviewed)
            .OrderByDescending(r => r.CreatedAt)
            .ToListAsync();
    }

    public async Task<FireReport?> GetByIdAsync(int id)
    {
        return await _context.FireReports
            .AsNoTracking()
            .FirstOrDefaultAsync(r => r.Id == id);
    }

    public async Task<FireReport> AddAsync(FireReport report)
    {
        _context.FireReports.Add(report);
        await _context.SaveChangesAsync();
        return report;
    }

    public async Task<int> GetCountAsync()
    {
        return await _context.FireReports.CountAsync();
    }

    public async Task<int> GetCountSinceAsync(DateTime since)
    {
        return await _context.FireReports.CountAsync(r => r.CreatedAt >= since);
    }
}
