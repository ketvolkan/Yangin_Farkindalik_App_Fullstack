import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/fire_report_controller.dart';

class FireReportView extends GetView<FireReportController> {
  const FireReportView({super.key});

  Future<void> _call112() async {
    final uri = Uri.parse('tel:112');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('🔥 Yangın İhbarı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.fireRedLight),
            tooltip: '112 Acil Çağrı',
            onPressed: _call112,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.submitSuccess.value) {
          return _buildSuccessView(context);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Notice banner
              _buildDisclaimerBanner(),
              const SizedBox(height: 18),

              // Fire Type Selection
              _buildSectionTitle('1. Yangın Türü'),
              const SizedBox(height: 10),
              _buildFireTypeSelector(),
              const SizedBox(height: 20),

              // Location Section
              _buildSectionTitle('2. Konum Bilgisi'),
              const SizedBox(height: 10),
              _buildLocationCard(),
              const SizedBox(height: 20),

              // Description Section
              _buildSectionTitle('3. Açıklama (Opsiyonel)'),
              const SizedBox(height: 10),
              TextField(
                controller: controller.descriptionController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: AppStrings.descriptionHint,
                ),
              ),
              const SizedBox(height: 20),

              // Photo Section
              _buildSectionTitle('4. Fotoğraf (Opsiyonel)'),
              const SizedBox(height: 10),
              _buildPhotoPicker(),
              const SizedBox(height: 24),

              // Error banner if any
              if (controller.errorMessage.value.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.fireRed.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.fireRedLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: AppColors.fireRedLight, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: AppColors.fireRedLight, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Submit Button
              CustomButton(
                text: AppStrings.submitReport,
                backgroundColor: AppColors.fireRed,
                icon: Icons.send_rounded,
                isLoading: controller.isSubmitting.value,
                height: 56,
                onPressed: controller.submitReport,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDisclaimerBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.fireRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fireRed.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: AppColors.fireRedLight, size: 20),
              SizedBox(width: 8),
              Text(
                'Önemli Güvenlik Uyarısı',
                style: TextStyle(
                  color: AppColors.fireRedLight,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            AppStrings.disclaimerFull,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFireTypeSelector() {
    return Obx(() {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: controller.fireTypes.map((type) {
          final isSelected = controller.selectedFireType.value == type.key;
          return InkWell(
            onTap: () => controller.selectedFireType.value = type.key,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.fireRed.withOpacity(0.2)
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.fireRed : AppColors.cardBorder,
                  width: isSelected ? 1.8 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(type.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    type.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Obx(() {
        if (controller.isFetchingLocation.value) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.orangeAccent),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  AppStrings.fetchingLocation,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          );
        }

        final lat = controller.latitude.value;
        final lng = controller.longitude.value;
        final hasError = controller.locationError.value.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (controller.isGpsAccurate.value
                            ? AppColors.greenSuccess
                            : AppColors.orangeAccent)
                        .withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.my_location_rounded,
                    color: controller.isGpsAccurate.value
                        ? AppColors.greenSuccess
                        : AppColors.orangeAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lat != null && lng != null
                            ? '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}'
                            : '37.8636, 27.2619',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        controller.isGpsAccurate.value
                            ? 'GPS Konumu Doğrulandı'
                            : 'Varsayılan Konum (Kuşadası / Ege)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: controller.isGpsAccurate.value
                              ? AppColors.greenSuccess
                              : AppColors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
                  tooltip: 'Konumu Yenile',
                  onPressed: controller.fetchCurrentLocation,
                ),
              ],
            ),
            if (hasError) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.yellowWarning),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        controller.locationError.value,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                    InkWell(
                      onTap: controller.openAppSettings,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'İzin Ver',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.orangeAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildPhotoPicker() {
    return Obx(() {
      final image = controller.selectedImage.value;
      if (image != null) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.file(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  onPressed: controller.removeImage,
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.fireRedLight, size: 18),
                  label: const Text(
                    AppStrings.removePhoto,
                    style: TextStyle(color: AppColors.fireRedLight, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => controller.pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt_rounded, size: 18, color: AppColors.orangeAccent),
              label: const Text(AppStrings.takePhoto, style: TextStyle(color: AppColors.textPrimary)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.cardBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => controller.pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_rounded, size: 18, color: AppColors.orangeAccent),
              label: const Text(AppStrings.chooseGallery, style: TextStyle(color: AppColors.textPrimary)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.cardBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSuccessView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.greenSuccess.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.greenSuccess.withOpacity(0.4)),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.greenSuccess,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.reportSuccessTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          const Text(
            AppStrings.reportSuccessMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),
          CustomButton(
            text: '🗺️ Haritada Görüntüle',
            backgroundColor: AppColors.surfaceLight,
            textColor: Colors.white,
            onPressed: () {
              controller.resetForm();
              Get.offNamed(Routes.map);
            },
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Ana Sayfaya Dön',
            backgroundColor: AppColors.cardBackground,
            textColor: AppColors.textSecondary,
            onPressed: () {
              controller.resetForm();
              Get.offNamed(Routes.home);
            },
          ),
        ],
      ),
    );
  }
}
