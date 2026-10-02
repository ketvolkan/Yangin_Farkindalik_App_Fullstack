using FireAlert.Domain.Entities;

namespace FireAlert.Application.Interfaces;

public interface IBlogRepository
{
    Task<List<BlogPost>> GetAllAsync();
    Task<BlogPost?> GetBySlugAsync(string slug);
}
