import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import '../../../core/storage/storage_service.dart';
import '../../../data/repositories/fire_report_repository.dart';

class FireTypeOption {
  final String key;
  final String label;
  final String emoji;
  final IconData icon;

  const FireTypeOption({
    required this.key,
    required this.label,
    required this.emoji,
    required this.icon,
  });
}

class FireReportController extends GetxController {
  final FireReportRepository _repository = Get.find<FireReportRepository>();
  final StorageService _storageService = Get.find<StorageService>();
  final ImagePicker _imagePicker = ImagePicker();

  final selectedFireType = 'Forest'.obs;
  final descriptionController = TextEditingController();
  final selectedImage = Rx<File?>(null);

  final latitude = Rx<double?>(37.8636);
  final longitude = Rx<double?>(27.2619);
  final isFetchingLocation = false.obs;
  final locationError = ''.obs;
  final isGpsAccurate = false.obs;

  final isSubmitting = false.obs;
  final submitSuccess = false.obs;
  final errorMessage = ''.obs;

  final List<FireTypeOption> fireTypes = const [
    FireTypeOption(key: 'Forest', label: 'Orman Yangını', emoji: '🌲', icon: Icons.forest_rounded),
    FireTypeOption(key: 'Building', label: 'Bina Yangını', emoji: '🏠', icon: Icons.apartment_rounded),
    FireTypeOption(key: 'Vehicle', label: 'Araç Yangını', emoji: '🚗', icon: Icons.directions_car_rounded),
    FireTypeOption(key: 'Electric', label: 'Elektrik Yangını', emoji: '⚡', icon: Icons.bolt_rounded),
    FireTypeOption(key: 'Other', label: 'Diğer Yangın', emoji: '🔥', icon: Icons.local_fire_department_rounded),
  ];

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchCurrentLocation() async {
    isFetchingLocation.value = true;
    locationError.value = '';

    try {
      // 1. Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        latitude.value = 37.8636;
        longitude.value = 27.2619;
        isGpsAccurate.value = false;
        locationError.value = 'Cihaz GPS servisi kapalı. Varsayılan konum uygulandı.';
        return;
      }

      // 2. Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          latitude.value = 37.8636;
          longitude.value = 27.2619;
          isGpsAccurate.value = false;
          locationError.value = 'Konum izni verilmedi (Varsayılan konum kullanılıyor).';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        latitude.value = 37.8636;
        longitude.value = 27.2619;
        isGpsAccurate.value = false;
        locationError.value = 'Konum izni reddedildi (Varsayılan konum kullanılıyor).';
        return;
      }

      // 3. Get accurate current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      isGpsAccurate.value = true;
      locationError.value = '';
    } catch (e) {
      latitude.value = 37.8636;
      longitude.value = 27.2619;
      isGpsAccurate.value = false;
      locationError.value = 'GPS sinyali alınamadı. Varsayılan konum seçildi.';
    } finally {
      isFetchingLocation.value = false;
    }
  }

  Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Fotoğraf Hatası',
        'Fotoğraf seçilirken sorun oluştu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  Future<void> submitReport() async {
    errorMessage.value = '';

    final reporterName = _storageService.getReporterName();
    if (reporterName == null || reporterName.trim().isEmpty) {
      errorMessage.value = 'Kullanıcı adı bulunamadı. Lütfen profilinizi kontrol edin.';
      return;
    }

    if (latitude.value == null || longitude.value == null) {
      errorMessage.value = 'Konum bilgisi alınamadı.';
      return;
    }

    isSubmitting.value = true;
    try {
      await _repository.createReport(
        reporterName: reporterName,
        fireType: selectedFireType.value,
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        latitude: latitude.value!,
        longitude: longitude.value!,
        imageUrl: null,
      );

      submitSuccess.value = true;
    } catch (e) {
      errorMessage.value = 'İhbar gönderilemedi: $e';
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetForm() {
    selectedFireType.value = 'Forest';
    descriptionController.clear();
    selectedImage.value = null;
    submitSuccess.value = false;
    errorMessage.value = '';
    fetchCurrentLocation();
  }
}
