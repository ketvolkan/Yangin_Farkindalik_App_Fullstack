class StatisticsModel {
  final int today;
  final int thisWeek;
  final int thisMonth;
  final int total;

  StatisticsModel({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.total,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      today: json['today'] is int ? json['today'] : int.tryParse(json['today'].toString()) ?? 0,
      thisWeek: json['thisWeek'] is int ? json['thisWeek'] : int.tryParse(json['thisWeek'].toString()) ?? 0,
      thisMonth: json['thisMonth'] is int ? json['thisMonth'] : int.tryParse(json['thisMonth'].toString()) ?? 0,
      total: json['total'] is int ? json['total'] : int.tryParse(json['total'].toString()) ?? 0,
    );
  }

  factory StatisticsModel.empty() {
    return StatisticsModel(today: 0, thisWeek: 0, thisMonth: 0, total: 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'today': today,
      'thisWeek': thisWeek,
      'thisMonth': thisMonth,
      'total': total,
    };
  }
}
