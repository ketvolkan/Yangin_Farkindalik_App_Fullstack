import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find<StorageService>();

  late final GetStorage _box;
  static const String _keyReporterName = 'reporter_name';
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // Reporter Name
  String? getReporterName() {
    return _box.read<String>(_keyReporterName);
  }

  Future<void> setReporterName(String name) async {
    await _box.write(_keyReporterName, name.trim());
    await _box.write(_keyHasCompletedOnboarding, true);
  }

  // Onboarding status
  bool hasCompletedOnboarding() {
    final hasCompleted = _box.read<bool>(_keyHasCompletedOnboarding) ?? false;
    final name = getReporterName();
    return hasCompleted && (name != null && name.trim().length >= 3);
  }

  Future<void> clearAll() async {
    await _box.erase();
  }
}
