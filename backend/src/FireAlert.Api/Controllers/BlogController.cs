using FireAlert.Application.DTOs;
using FireAlert.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace FireAlert.Api.Controllers;

[ApiController]
[Route("api/blog")]
public class BlogController : ControllerBase
{
    private readonly IBlogService _blogService;

    public BlogController(IBlogService blogService)
    {
        _blogService = blogService;
    }

    [HttpGet]
    public async Task<ActionResult<List<BlogPostDto>>> GetAll()
    {
        var posts = await _blogService.GetBlogPostsAsync();
        return Ok(posts);
    }

    [HttpGet("{slug}")]
    public async Task<ActionResult<BlogPostDto>> GetBySlug(string slug)
    {
        var post = await _blogService.GetBlogPostBySlugAsync(slug);
        if (post == null)
        {
            return NotFound(new { message = $"'{slug}' başlıklı blog yazısı bulunamadı." });
        }
        return Ok(post);
    }
}
