// test/lib/app/models/weekly_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:clima_app2/app/data/models/daily_forecast/daily_forecast.dart';

void main() {
  group('DailyForecast', () {
    test('fromJson deve desserializar corretamente', () {
      final json = {
        'date': 1627776000000,
        'maxTemp': 30.5,
        'minTemp': 20.2,
        'condition': 'Clear',
        'icon': '01d',
        'precipitation': 0.0,
      };

      final forecast = DailyForecast.fromJson(json);

      expect(forecast.date, DateTime.fromMillisecondsSinceEpoch(1627776000000));
      expect(forecast.maxTemp, 30.5);
      expect(forecast.minTemp, 20.2);
      expect(forecast.condition, 'Clear');
      expect(forecast.icon, '01d');
      expect(forecast.precipitation, 0.0);
    });

    test('toJson deve serializar corretamente', () {
      final forecast = DailyForecast(
        date: DateTime.fromMillisecondsSinceEpoch(1627776000000),
        maxTemp: 30.5,
        minTemp: 20.2,
        condition: 'Clear',
        icon: '01d',
        precipitation: 0.0,
      );

      final json = forecast.toJson();

      expect(json['date'], 1627776000000);
      expect(json['maxTemp'], 30.5);
      expect(json['minTemp'], 20.2);
      expect(json['condition'], 'Clear');
      expect(json['icon'], '01d');
      expect(json['precipitation'], 0.0);
    });

    test(
      'fromJson deve aplicar valores padrão quando campos estão ausentes',
      () {
        final json = {
          'date': 1627776000000,
          // maxTemp ausente
          // minTemp ausente
          // condition ausente
          // icon ausente
          // precipitation ausente
        };

        final forecast = DailyForecast.fromJson(json);

        expect(forecast.maxTemp, 0.0);
        expect(forecast.minTemp, 0.0);
        expect(forecast.condition, 'Indefinido');
        expect(forecast.icon, '01d');
        expect(forecast.precipitation, 0.0);
      },
    );
  });
}
