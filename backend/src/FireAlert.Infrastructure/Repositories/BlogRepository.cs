using FireAlert.Application.Interfaces;
using FireAlert.Domain.Entities;
using FireAlert.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace FireAlert.Infrastructure.Repositories;

public class BlogRepository : IBlogRepository
{
    private readonly FireAlertDbContext _context;

    public BlogRepository(FireAlertDbContext context)
    {
        _context = context;
    }

    public async Task<List<BlogPost>> GetAllAsync()
    {
        return await _context.BlogPosts
            .AsNoTracking()
            .OrderByDescending(p => p.CreatedAt)
            .ToListAsync();
    }

    public async Task<BlogPost?> GetBySlugAsync(string slug)
    {
        return await _context.BlogPosts
            .AsNoTracking()
            .FirstOrDefaultAsync(p => p.Slug.ToLower() == slug.ToLower());
    }
}
