class WeeklyForecast {
  final List<DailyForecast> daily;

  WeeklyForecast({required this.daily});

  factory WeeklyForecast.fromJson(Map<String, dynamic> json) {
    final dailyData = <DateTime, List<Map<String, dynamic>>>{};

    // Agrupar previsões por dia
    for (var item in json['list']) {
      final timestamp = item['dt'] as int?;
      if (timestamp == null) continue;

      final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      final dayKey = DateTime(date.year, date.month, date.day);

      dailyData.putIfAbsent(dayKey, () => []).add(item);
    }

    // Ordenar os dias para garantir consistência
    final sortedDays = dailyData.keys.toList()..sort();

    final dailyForecasts =
        sortedDays
            .map((day) {
              final hourlyData = dailyData[day]!;
              final temps =
                  hourlyData
                      .map(
                        (h) => (h['main']?['temp'] as num?)?.toDouble() ?? 0.0,
                      )
                      .toList();

              final weather = hourlyData.first['weather']?[0];
              final condition = weather?['description'] ?? 'Indefinido';
              final icon = weather?['icon'] ?? '01d';

              final precipitation =
                  hourlyData.fold<double>(0.0, (sum, h) {
                    final pop = (h['pop'] as num?)?.toDouble() ?? 0.0;
                    return sum + pop;
                  }) /
                  hourlyData.length;

              return DailyForecast(
                date: day,
                maxTemp: temps.reduce((a, b) => a > b ? a : b),
                minTemp: temps.reduce((a, b) => a < b ? a : b),
                condition: condition,
                icon: icon,
                precipitation: precipitation,
              );
            })
            .take(7)
            .toList();

    return WeeklyForecast(daily: dailyForecasts);
  }

  Map<String, dynamic> toJson() => {
    'daily': daily.map((day) => day.toJson()).toList(),
  };
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
