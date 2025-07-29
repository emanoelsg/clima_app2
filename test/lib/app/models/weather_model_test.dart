// test/lib/app/models/weather_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/models/daily_forecast/daily_forecast.dart';
import 'package:clima_app2/app/models/hourly_model/hourly_model.dart';
import 'package:clima_app2/app/models/weekly_model/weekly_forecast_model.dart';

void main() {
  group('WeatherModel', () {
    test('fromJson e toJson funcionam corretamente', () {
      final json = {
        'coord': {'lon': -42.0, 'lat': -19.0},
        'weather': [
          {
            'id': 800,
            'main': 'Clear',
            'description': 'céu limpo',
            'icon': '01d',
          }
        ],
        'base': 'stations',
        'main': {
          'temp': 25.0,
          'feels_like': 26.0,
          'temp_min': 22.0,
          'temp_max': 28.0,
          'pressure': 1013,
          'humidity': 60,
          'sea_level': 1013,
          'grnd_level': 1000,
        },
        'visibility': 10000,
        'wind': {'speed': 5.0, 'deg': 180, 'gust': 7.0},
        'rain': {'1h': 0.0},
        'clouds': {'all': 0},
        'dt': 1690000000,
        'sys': {
          'type': 1,
          'id': 1234,
          'country': 'BR',
          'sunrise': 1690000000,
          'sunset': 1690040000,
        },
        'timezone': -10800,
        'id': 123456,
        'name': 'Caratinga',
        'cod': 200,
      };

      final model = WeatherModel.fromJson(json);
      final backToJson = model.toJson();

      expect(model.name, 'Caratinga');
      expect(model.main?.temp, 25.0);
      expect(backToJson['name'], 'Caratinga');
      expect(backToJson['main']['temp'], 25.0);
    });
  });

  group('DailyForecast', () {
    test('fromJson e toJson funcionam corretamente', () {
      final json = {
        'date': DateTime(2025, 7, 27).millisecondsSinceEpoch,
        'maxTemp': 30.0,
        'minTemp': 20.0,
        'condition': 'Clear',
        'icon': '01d',
        'precipitation': 0.1,
      };

      final forecast = DailyForecast.fromJson(json);
      final backToJson = forecast.toJson();

      expect(forecast.maxTemp, 30.0);
      expect(backToJson['condition'], 'Clear');
      expect(backToJson['icon'], '01d');
    });
  });

  group('HourlyForecast', () {
    test('criação direta funciona corretamente', () {
      final forecast = HourlyForecast(time: '12:00', iconCode: '01d', temp: 25);

      expect(forecast.time, '12:00');
      expect(forecast.iconCode, '01d');
      expect(forecast.temp, 25);
    });
  });

  group('WeeklyForecast', () {
    test('fromJson agrupa corretamente os dados por dia', () {
      final mockJson = {
        'list': [
          {
            'dt': DateTime(2025, 7, 27, 9).millisecondsSinceEpoch ~/ 1000,
            'main': {'temp': 22.0},
            'weather': [
              {'description': 'Clear sky', 'icon': '01d'}
            ],
            'pop': 0.1,
          },
          {
            'dt': DateTime(2025, 7, 27, 15).millisecondsSinceEpoch ~/ 1000,
            'main': {'temp': 28.0},
            'weather': [
              {'description': 'Clear sky', 'icon': '01d'}
            ],
            'pop': 0.0,
          },
        ]
      };

      final forecast = WeeklyForecast.fromJson(mockJson);

      expect(forecast.daily.length, 1);
      final day = forecast.daily.first;
      expect(day.maxTemp, 28.0);
      expect(day.minTemp, 22.0);
      expect(day.condition, 'Clear sky');
      expect(day.precipitation, closeTo(0.05, 0.01));
    });
  });
}