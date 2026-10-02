import 'package:get/get.dart';
import '../../modules/blog/bindings/blog_binding.dart';
import '../../modules/blog/views/blog_detail_view.dart';
import '../../modules/blog/views/blog_list_view.dart';
import '../../modules/fire_report/bindings/fire_report_binding.dart';
import '../../modules/fire_report/views/fire_report_view.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/map/bindings/map_binding.dart';
import '../../modules/map/views/map_view.dart';
import '../../modules/onboarding/bindings/onboarding_binding.dart';
import '../../modules/onboarding/views/onboarding_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.fireReport,
      page: () => const FireReportView(),
      binding: FireReportBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.map,
      page: () => const MapView(),
      binding: MapBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.blogList,
      page: () => const BlogListView(),
      binding: BlogBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.blogDetail,
      page: () => const BlogDetailView(),
      binding: BlogBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
