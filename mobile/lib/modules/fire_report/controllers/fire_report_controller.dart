import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  final latitude = Rx<double?>(null);
  final longitude = Rx<double?>(null);
  final isFetchingLocation = false.obs;
  final locationError = ''.obs;

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
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Fallback default coordinates (Izmir / Turkey area) if GPS disabled
        latitude.value = 38.4237;
        longitude.value = 27.1428;
        locationError.value = 'Konum servisi kapalı. Varsayılan konum uygulandı.';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          latitude.value = 38.4237;
          longitude.value = 27.1428;
          locationError.value = 'Konum izni verilmedi. Varsayılan konum uygulandı.';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        latitude.value = 38.4237;
        longitude.value = 27.1428;
        locationError.value = 'Konum izni kalıcı olarak reddedildi.';
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      locationError.value = '';
    } catch (e) {
      // Fallback sensible coordinates for demo
      latitude.value = 37.8636;
      longitude.value = 27.2619;
      locationError.value = 'Konum alınamadı: $e';
    } finally {
      isFetchingLocation.value = false;
    }
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
      errorMessage.value = 'Konum bilgisi alınamadı. Lütfen konum servislerini açın.';
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
        imageUrl: null, // Image URL can be populated after upload or null in MVP
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
