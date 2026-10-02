import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/fire_report_model.dart';
import '../models/statistics_model.dart';

class FireReportProvider {
  final ApiClient _client;

  FireReportProvider(this._client);

  Future<List<FireReportModel>> getAllReports() async {
    final response = await _client.get(ApiConstants.fireReports);
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((item) => FireReportModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<FireReportModel>> getActiveReports() async {
    final response = await _client.get(ApiConstants.activeFireReports);
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((item) => FireReportModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<FireReportModel?> getReportById(int id) async {
    final response = await _client.get('${ApiConstants.fireReports}/$id');
    if (response.statusCode == 200 && response.data != null) {
      return FireReportModel.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<FireReportModel> createReport({
    required String reporterName,
    required String fireType,
    String? description,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) async {
    final payload = {
      'reporterName': reporterName,
      'fireType': fireType,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
    };

    final response = await _client.post(ApiConstants.fireReports, data: payload);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return FireReportModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception('Yangın ihbarı gönderilemedi (Status: ${response.statusCode})');
  }

  Future<StatisticsModel> getStatistics() async {
    final response = await _client.get(ApiConstants.statistics);
    if (response.statusCode == 200 && response.data != null) {
      return StatisticsModel.fromJson(response.data as Map<String, dynamic>);
    }
    return StatisticsModel.empty();
  }
}
