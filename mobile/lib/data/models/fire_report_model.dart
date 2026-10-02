class FireReportModel {
  final int id;
  final String reporterName;
  final String fireType;
  final String? description;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FireReportModel({
    required this.id,
    required this.reporterName,
    required this.fireType,
    this.description,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.status = 'Reported',
    required this.createdAt,
    this.updatedAt,
  });

  factory FireReportModel.fromJson(Map<String, dynamic> json) {
    return FireReportModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      reporterName: json['reporterName'] as String? ?? '',
      fireType: json['fireType'] as String? ?? 'Other',
      description: json['description'] as String?,
      latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : 0.0,
      longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : 0.0,
      imageUrl: json['imageUrl'] as String?,
      status: json['status'] as String? ?? 'Reported',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporterName': reporterName,
      'fireType': fireType,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'reporterName': reporterName,
      'fireType': fireType,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
    };
  }
}
