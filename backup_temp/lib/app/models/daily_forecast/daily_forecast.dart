class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
<<<<<<< HEAD
  final String condition;
=======
  final String description;
>>>>>>> 906cca7 (Initial commit)
  final String icon;
  final double precipitation;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
<<<<<<< HEAD
    required this.condition,
=======
    required this.description,
>>>>>>> 906cca7 (Initial commit)
    required this.icon,
    required this.precipitation,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      maxTemp: (json['maxTemp'] as num?)?.toDouble() ?? 0.0,
      minTemp: (json['minTemp'] as num?)?.toDouble() ?? 0.0,
<<<<<<< HEAD
      condition: json['condition'] ?? 'Indefinido',
=======
      description: json['description'] ?? 'Indefinido',
>>>>>>> 906cca7 (Initial commit)
      icon: json['icon'] ?? '01d',
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.millisecondsSinceEpoch,
    'maxTemp': maxTemp,
    'minTemp': minTemp,
<<<<<<< HEAD
    'condition': condition,
=======
    'description': description,
>>>>>>> 906cca7 (Initial commit)
    'icon': icon,
    'precipitation': precipitation,
  };
}