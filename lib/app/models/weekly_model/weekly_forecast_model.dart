class WeeklyForecast {
  final List<DailyForecast> daily;

  WeeklyForecast({required this.daily});

  factory WeeklyForecast.fromJson(Map<String, dynamic> json) {
    // Processa os dados da API para agrupar por dia
    final dailyForecasts = <DailyForecast>[];
    final dailyData = <DateTime, List<Map<String, dynamic>>>{};
    
    // Agrupa os dados por dia (a API retorna de 3 em 3 horas)
    for (var item in json['list']) {
      final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final dayStart = DateTime(date.year, date.month, date.day);
      
      if (!dailyData.containsKey(dayStart)) {
        dailyData[dayStart] = [];
      }
      dailyData[dayStart]!.add(item);
    }

    // Cria os objetos DailyForecast para cada dia
    dailyData.forEach((day, hourlyData) {
      final temps = hourlyData.map((h) => h['main']['temp'].toDouble()).toList();
      final weather = hourlyData[0]['weather'][0]; // Usa o primeiro registro do dia

      dailyForecasts.add(DailyForecast(
        date: day,
        maxTemp: temps.reduce((a, b) => a > b ? a : b), // Temperatura máxima do dia
        minTemp: temps.reduce((a, b) => a < b ? a : b), // Temperatura mínima do dia
        condition: weather['description'],
        icon: weather['icon'],
        precipitation: hourlyData.fold(0.0, (sum, h) => sum + (h['pop'] ?? 0.0)) / hourlyData.length,
      ));
    });

    return WeeklyForecast(
      daily: dailyForecasts.take(7).toList(), // Pegar apenas 7 dias
    );
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
  final double precipitation; // Probabilidade de precipitação (0-1)

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
      maxTemp: json['temp']['max']?.toDouble() ?? 0.0,
      minTemp: json['temp']['min']?.toDouble() ?? 0.0,
      condition: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      precipitation: json['pop']?.toDouble() ?? 0.0,
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

