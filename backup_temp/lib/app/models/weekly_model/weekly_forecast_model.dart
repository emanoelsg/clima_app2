import 'package:clima_app2/app/models/daily_forecast/daily_forecast.dart';

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
<<<<<<< HEAD
                condition: condition,
=======
                description: condition,
>>>>>>> 906cca7 (Initial commit)
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


