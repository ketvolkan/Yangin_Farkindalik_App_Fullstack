import 'package:get/get.dart';
import '../../../data/models/blog_post_model.dart';
import '../../../data/repositories/blog_repository.dart';

class BlogController extends GetxController {
  final BlogRepository _repository = Get.find<BlogRepository>();

  final blogPosts = <BlogPostModel>[].obs;
  final isLoading = true.obs;
  final selectedPost = Rx<BlogPostModel?>(null);
  final isDetailLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBlogPosts();
    final slug = Get.arguments as String?;
    if (slug != null) {
      loadPostBySlug(slug);
    }
  }

  Future<void> loadBlogPosts() async {
    isLoading.value = true;
    try {
      final posts = await _repository.getBlogPosts();
      blogPosts.assignAll(posts);
    } catch (e) {
      Get.snackbar(
        'Yükleme Hatası',
        'Blog yazıları yüklenirken hata oluştu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPostBySlug(String slug) async {
    isDetailLoading.value = true;
    try {
      final post = await _repository.getBlogPostBySlug(slug);
      selectedPost.value = post;
    } catch (e) {
      // Find in existing cache if network fails
      final cached = blogPosts.firstWhereOrNull((p) => p.slug == slug);
      selectedPost.value = cached;
    } finally {
      isDetailLoading.value = false;
    }
  }
}
