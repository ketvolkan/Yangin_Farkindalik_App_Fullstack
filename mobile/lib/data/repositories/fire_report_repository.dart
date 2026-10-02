import '../models/fire_report_model.dart';
import '../models/statistics_model.dart';
import '../providers/fire_report_provider.dart';

class FireReportRepository {
  final FireReportProvider _provider;

  FireReportRepository(this._provider);

  Future<List<FireReportModel>> getAllReports() => _provider.getAllReports();

  Future<List<FireReportModel>> getActiveReports() => _provider.getActiveReports();

  Future<FireReportModel?> getReportById(int id) => _provider.getReportById(id);

  Future<FireReportModel> createReport({
    required String reporterName,
    required String fireType,
    String? description,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) =>
      _provider.createReport(
        reporterName: reporterName,
        fireType: fireType,
        description: description,
        latitude: latitude,
        longitude: longitude,
        imageUrl: imageUrl,
      );

  Future<StatisticsModel> getStatistics() => _provider.getStatistics();
}
