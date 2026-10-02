import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/models/fire_report_model.dart';
import '../../../data/repositories/fire_report_repository.dart';

class FireMapController extends GetxController {
  final FireReportRepository _repository = Get.find<FireReportRepository>();
  final fmap.MapController flutterMapController = fmap.MapController();

  final activeReports = <FireReportModel>[].obs;
  final isLoading = true.obs;
  final selectedReport = Rx<FireReportModel?>(null);
  final mapCenter = const LatLng(38.9637, 35.2433).obs; // Turkey center default
  final mapZoom = 6.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadActiveFires();
  }

  Future<void> loadActiveFires() async {
    isLoading.value = true;
    try {
      final reports = await _repository.getActiveReports();
      activeReports.assignAll(reports);

      if (reports.isNotEmpty) {
        final latest = reports.first;
        mapCenter.value = LatLng(latest.latitude, latest.longitude);
        mapZoom.value = 10.0;
        flutterMapController.move(LatLng(latest.latitude, latest.longitude), 9.0);
      }
    } catch (e) {
      Get.snackbar(
        'Harita Yüklenemedi',
        'Aktif yangınlar alınırken hata oluştu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectReport(FireReportModel report) {
    selectedReport.value = report;
    flutterMapController.move(LatLng(report.latitude, report.longitude), 12.0);
  }

  void clearSelection() {
    selectedReport.value = null;
  }
}
