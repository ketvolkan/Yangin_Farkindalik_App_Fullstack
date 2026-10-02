import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/storage/storage_service.dart';

class OnboardingController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameRequired;
    }
    if (value.trim().length < 3) {
      return AppStrings.nameMinLength;
    }
    return null;
  }

  Future<void> submit() async {
    errorMessage.value = '';
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      try {
        final name = nameController.text.trim();
        await _storageService.setReporterName(name);
        Get.offAllNamed(Routes.home);
      } catch (e) {
        errorMessage.value = 'Kayıt sırasında bir hata oluştu: $e';
      } finally {
        isLoading.value = false;
      }
    }
  }
}
