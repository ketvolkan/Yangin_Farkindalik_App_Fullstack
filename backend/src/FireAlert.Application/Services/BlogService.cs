using FireAlert.Application.DTOs;
using FireAlert.Application.Interfaces;
using FireAlert.Domain.Entities;

namespace FireAlert.Application.Services;

public class BlogService : IBlogService
{
    private readonly IBlogRepository _repository;

    public BlogService(IBlogRepository repository)
    {
        _repository = repository;
    }

    public async Task<List<BlogPostDto>> GetBlogPostsAsync()
    {
        var posts = await _repository.GetAllAsync();
        return posts.Select(MapToDto).ToList();
    }

    public async Task<BlogPostDto?> GetBlogPostBySlugAsync(string slug)
    {
        var post = await _repository.GetBySlugAsync(slug);
        return post == null ? null : MapToDto(post);
    }

    private static BlogPostDto MapToDto(BlogPost post)
    {
        return new BlogPostDto
        {
            Id = post.Id,
            Title = post.Title,
            Slug = post.Slug,
            Content = post.Content,
            CoverImageUrl = post.CoverImageUrl,
            CreatedAt = post.CreatedAt,
            UpdatedAt = post.UpdatedAt
        };
    }
}
