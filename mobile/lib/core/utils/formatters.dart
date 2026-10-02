import 'package:intl/intl.dart';

class Formatters {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime.toLocal());
  }

  static String formatTimeOnly(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime.toLocal());
  }

  static String formatDateOnly(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy', 'tr_TR').format(dateTime.toLocal());
  }

  static String formatCoordinates(double lat, double lng) {
    return '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  }

  static String fireTypeToTurkish(String fireType) {
    switch (fireType.toLowerCase()) {
      case 'forest':
        return 'Orman Yangını';
      case 'building':
        return 'Bina Yangını';
      case 'vehicle':
        return 'Araç Yangını';
      case 'electric':
        return 'Elektrik Yangını';
      case 'other':
      default:
        return 'Diğer Yangın';
    }
  }

  static String fireTypeToEmoji(String fireType) {
    switch (fireType.toLowerCase()) {
      case 'forest':
        return '🌲';
      case 'building':
        return '🏠';
      case 'vehicle':
        return '🚗';
      case 'electric':
        return '⚡';
      case 'other':
      default:
        return '🔥';
    }
  }
}
