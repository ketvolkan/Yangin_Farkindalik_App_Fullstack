import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }
    try {
      if (Platform.isAndroid) {
        // Android emulator localhost alias
        return 'http://10.0.2.2:5000/api';
      }
    } catch (_) {}
    return 'http://localhost:5000/api';
  }

  // Endpoints
  static const String fireReports = '/fire-reports';
  static const String activeFireReports = '/fire-reports/active';
  static const String statistics = '/statistics';
  static const String blog = '/blog';
}
