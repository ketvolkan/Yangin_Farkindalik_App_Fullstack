import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:firealert_mobile/core/constants/app_strings.dart';
import 'package:firealert_mobile/core/storage/storage_service.dart';
import 'package:firealert_mobile/core/utils/formatters.dart';
import 'package:firealert_mobile/data/models/fire_report_model.dart';
import 'package:firealert_mobile/data/models/statistics_model.dart';
import 'package:firealert_mobile/modules/onboarding/controllers/onboarding_controller.dart';

class MockStorageService extends StorageService {
  String? _name;

  @override
  String? getReporterName() => _name;

  @override
  Future<void> setReporterName(String name) async {
    _name = name;
  }

  @override
  bool hasCompletedOnboarding() => _name != null && _name!.trim().length >= 3;
}

void main() {
  setUp(() {
    Get.reset();
    Get.put<StorageService>(MockStorageService());
  });

  group('Onboarding Validation Tests', () {
    test('Empty name should return required error', () {
      final controller = OnboardingController();
      final result = controller.validateName('');
      expect(result, AppStrings.nameRequired);
    });

    test('Name with less than 3 chars should return minLength error', () {
      final controller = OnboardingController();
      final result = controller.validateName('Vo');
      expect(result, AppStrings.nameMinLength);
    });

    test('Valid name should return null error', () {
      final controller = OnboardingController();
      final result = controller.validateName('Volkan Ket');
      expect(result, isNull);
    });
  });

  group('Formatters Tests', () {
    test('Format coordinates correctly', () {
      final formatted = Formatters.formatCoordinates(37.863612, 27.261945);
      expect(formatted, '37.8636, 27.2619');
    });

    test('Fire type to Turkish translation', () {
      expect(Formatters.fireTypeToTurkish('Forest'), 'Orman Yangını');
      expect(Formatters.fireTypeToTurkish('Building'), 'Bina Yangını');
      expect(Formatters.fireTypeToTurkish('Vehicle'), 'Araç Yangını');
      expect(Formatters.fireTypeToTurkish('Electric'), 'Elektrik Yangını');
      expect(Formatters.fireTypeToTurkish('Other'), 'Diğer Yangın');
    });

    test('Fire type to Emoji', () {
      expect(Formatters.fireTypeToEmoji('Forest'), '🌲');
      expect(Formatters.fireTypeToEmoji('Building'), '🏠');
      expect(Formatters.fireTypeToEmoji('Vehicle'), '🚗');
      expect(Formatters.fireTypeToEmoji('Electric'), '⚡');
    });
  });

  group('FireReportModel Tests', () {
    test('JSON serialization & deserialization', () {
      final json = {
        'id': 1,
        'reporterName': 'Volkan Ket',
        'fireType': 'Forest',
        'description': 'Yoğun duman',
        'latitude': 37.8636,
        'longitude': 27.2619,
        'imageUrl': null,
        'status': 'Reported',
        'createdAt': '2026-10-02T13:42:00.000Z',
      };

      final model = FireReportModel.fromJson(json);
      expect(model.id, 1);
      expect(model.reporterName, 'Volkan Ket');
      expect(model.fireType, 'Forest');
      expect(model.latitude, 37.8636);
      expect(model.longitude, 27.2619);
      expect(model.description, 'Yoğun duman');

      final createJson = model.toCreateJson();
      expect(createJson['reporterName'], 'Volkan Ket');
      expect(createJson['fireType'], 'Forest');
    });
  });

  group('StatisticsModel Tests', () {
    test('JSON deserialization', () {
      final json = {
        'today': 12,
        'thisWeek': 48,
        'thisMonth': 137,
        'total': 421,
      };

      final model = StatisticsModel.fromJson(json);
      expect(model.today, 12);
      expect(model.thisWeek, 48);
      expect(model.thisMonth, 137);
      expect(model.total, 421);
    });
  });
}
