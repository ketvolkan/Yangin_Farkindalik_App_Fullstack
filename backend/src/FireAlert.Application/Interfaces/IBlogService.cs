using FireAlert.Application.DTOs;

namespace FireAlert.Application.Interfaces;

public interface IBlogService
{
    Task<List<BlogPostDto>> GetBlogPostsAsync();
    Task<BlogPostDto?> GetBlogPostBySlugAsync(String slug);
}
