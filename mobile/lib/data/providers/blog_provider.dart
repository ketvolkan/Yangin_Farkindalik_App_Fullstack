import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/blog_post_model.dart';

class BlogProvider {
  final ApiClient _client;

  BlogProvider(this._client);

  Future<List<BlogPostModel>> getBlogPosts() async {
    final response = await _client.get(ApiConstants.blog);
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((item) => BlogPostModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<BlogPostModel?> getBlogPostBySlug(String slug) async {
    final response = await _client.get('${ApiConstants.blog}/$slug');
    if (response.statusCode == 200 && response.data != null) {
      return BlogPostModel.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }
}
