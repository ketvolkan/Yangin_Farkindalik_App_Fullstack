import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/fire_report_model.dart';
import '../controllers/map_controller.dart';

class MapView extends GetView<FireMapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.mapTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Haritayı Yenile',
            onPressed: controller.loadActiveFires,
          ),
        ],
      ),
      body: Obx(() {
        final reports = controller.activeReports;
        final selected = controller.selectedReport.value;

        return Stack(
          children: [
            // Map View
            FlutterMap(
              mapController: controller.flutterMapController,
              options: MapOptions(
                initialCenter: controller.mapCenter.value,
                initialZoom: controller.mapZoom.value,
                onTap: (_, __) => controller.clearSelection(),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.firealert.mobile',
                  tileBuilder: (context, widget, tile) {
                    // Slight dark filter overlay for dark mode aesthetic
                    return ColorFiltered(
                      colorFilter: const ColorFilter.matrix(<double>[
                        0.33, 0.33, 0.33, 0, -30, // Red
                        0.33, 0.33, 0.33, 0, -30, // Green
                        0.33, 0.33, 0.33, 0, -30, // Blue
                        0,    0,    0,    1,   0, // Alpha
                      ]),
                      child: widget,
                    );
                  },
                ),
                MarkerLayer(
                  markers: reports.map((report) {
                    final isSelected = selected?.id == report.id;
                    return Marker(
                      point: LatLng(report.latitude, report.longitude),
                      width: isSelected ? 50 : 40,
                      height: isSelected ? 50 : 40,
                      child: GestureDetector(
                        onTap: () => controller.selectReport(report),
                        child: _buildMarkerWidget(report, isSelected),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Top Status Badge
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.fireRed,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${reports.length} Aktif İhbar',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading Indicator
            if (controller.isLoading.value)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.fireRed),
                    ),
                  ),
                ),
              ),

            // Bottom Selected Report Card
            if (selected != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: _buildSelectedCard(selected),
              ),

            // Floating Quick Report button if no marker selected
            if (selected == null)
              Positioned(
                right: 16,
                bottom: 20,
                child: FloatingActionButton.extended(
                  onPressed: () => Get.toNamed(Routes.fireReport),
                  backgroundColor: AppColors.fireRed,
                  icon: const Icon(Icons.local_fire_department_rounded, color: Colors.white),
                  label: const Text(
                    'İhbar Ver',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildMarkerWidget(FireReportModel report, bool isSelected) {
    return AnimatedScale(
      scale: isSelected ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.fireRed,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.fireRed.withOpacity(0.7),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            Formatters.fireTypeToEmoji(report.fireType),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCard(FireReportModel report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.fireRed.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    Formatters.fireTypeToEmoji(report.fireType),
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Formatters.fireTypeToTurkish(report.fireType),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textMuted),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: controller.clearSelection,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.orangeAccent),
              const SizedBox(width: 6),
              Text(
                report.reporterName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                Formatters.formatTimeOnly(report.createdAt),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.fireRedLight),
              const SizedBox(width: 6),
              Text(
                Formatters.formatCoordinates(report.latitude, report.longitude),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (report.description != null && report.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                report.description!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
