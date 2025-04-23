class WeeklyForecast {
  final List<DailyForecast> daily;

  WeeklyForecast({required this.daily});

  factory WeeklyForecast.fromJson(Map<String, dynamic> json) {
    return WeeklyForecast(
      daily: List<DailyForecast>.from(
        json['list'].map((x) => DailyForecast.fromJson(x))
      ),
    );
  }
}

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
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      maxTemp: json['temp']['max'].toDouble(),
      minTemp: json['temp']['min'].toDouble(),
      condition: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      precipitation: json['pop']?.toDouble() ?? 0.0,
    );
  }
}