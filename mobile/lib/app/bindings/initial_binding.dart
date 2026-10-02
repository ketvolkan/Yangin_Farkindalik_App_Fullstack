import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/storage_service.dart';
import '../../data/providers/blog_provider.dart';
import '../../data/providers/fire_report_provider.dart';
import '../../data/repositories/blog_repository.dart';
import '../../data/repositories/fire_report_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Providers
    Get.lazyPut<FireReportProvider>(() => FireReportProvider(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<BlogProvider>(() => BlogProvider(Get.find<ApiClient>()), fenix: true);

    // Repositories
    Get.lazyPut<FireReportRepository>(
      () => FireReportRepository(Get.find<FireReportProvider>()),
      fenix: true,
    );
    Get.lazyPut<BlogRepository>(
      () => BlogRepository(Get.find<BlogProvider>()),
      fenix: true,
    );
  }
}
