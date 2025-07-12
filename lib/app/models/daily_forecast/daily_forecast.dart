class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String icon;
  final double precipitation;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
    required this.precipitation,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      maxTemp: (json['maxTemp'] as num?)?.toDouble() ?? 0.0,
      minTemp: (json['minTemp'] as num?)?.toDouble() ?? 0.0,
      condition: json['condition'] ?? 'Indefinido',
      icon: json['icon'] ?? '01d',
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.millisecondsSinceEpoch,
    'maxTemp': maxTemp,
    'minTemp': minTemp,
    'condition': condition,
    'icon': icon,
    'precipitation': precipitation,
  };
}