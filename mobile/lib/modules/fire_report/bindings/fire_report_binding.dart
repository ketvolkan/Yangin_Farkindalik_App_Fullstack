import 'package:get/get.dart';
import '../controllers/fire_report_controller.dart';

class FireReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FireReportController>(() => FireReportController());
  }
}
