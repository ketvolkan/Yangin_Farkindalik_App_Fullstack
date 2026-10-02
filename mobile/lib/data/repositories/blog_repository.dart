import '../models/blog_post_model.dart';
import '../providers/blog_provider.dart';

class BlogRepository {
  final BlogProvider _provider;

  BlogRepository(this._provider);

  Future<List<BlogPostModel>> getBlogPosts() => _provider.getBlogPosts();

  Future<BlogPostModel?> getBlogPostBySlug(String slug) => _provider.getBlogPostBySlug(slug);
}
