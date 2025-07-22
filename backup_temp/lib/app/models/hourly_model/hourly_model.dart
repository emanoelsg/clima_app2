class HourlyForecast {
  final String time;
  final String iconCode;
  final int temp;
<<<<<<< HEAD
=======
  final int feelsLike;
  final double windSpeed;
  final int humidity;
>>>>>>> 906cca7 (Initial commit)

  HourlyForecast({
    required this.time,
    required this.iconCode,
    required this.temp,
<<<<<<< HEAD
  });
=======
    required this.feelsLike,
    required this.windSpeed,
    required this.humidity,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    final dt = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    final formattedTime = '${dt.hour.toString().padLeft(2, '0')}:00';

    return HourlyForecast(
      time: formattedTime,
      iconCode: json['weather'][0]['icon'],
      temp: (json['main']['temp'] as num).round(),
      feelsLike: (json['main']['feels_like'] as num).round(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
    );
  }
>>>>>>> 906cca7 (Initial commit)
}