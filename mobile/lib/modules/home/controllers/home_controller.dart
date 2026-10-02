import 'package:get/get.dart';
import '../../../core/storage/storage_service.dart';
import '../../../data/models/blog_post_model.dart';
import '../../../data/models/fire_report_model.dart';
import '../../../data/models/statistics_model.dart';
import '../../../data/repositories/blog_repository.dart';
import '../../../data/repositories/fire_report_repository.dart';

class HomeController extends GetxController {
  final FireReportRepository _fireRepository = Get.find<FireReportRepository>();
  final BlogRepository _blogRepository = Get.find<BlogRepository>();
  final StorageService _storageService = Get.find<StorageService>();

  final userName = ''.obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  final activeFires = <FireReportModel>[].obs;
  final statistics = Rx<StatisticsModel>(StatisticsModel.empty());
  final recentBlogPosts = <BlogPostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadDashboardData();
  }

  void loadUserData() {
    final name = _storageService.getReporterName() ?? 'Gönüllü';
    userName.value = name.split(' ').first;
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final futures = await Future.wait([
        _fireRepository.getActiveReports().catchError((_) => <FireReportModel>[]),
        _fireRepository.getStatistics().catchError((_) => StatisticsModel.empty()),
        _blogRepository.getBlogPosts().catchError((_) => <BlogPostModel>[]),
      ]);

      activeFires.assignAll(futures[0] as List<FireReportModel>);
      statistics.value = futures[1] as StatisticsModel;
      final blogs = futures[2] as List<BlogPostModel>;
      recentBlogPosts.assignAll(blogs.take(3).toList());
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Veriler yüklenirken sorun oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }
}
