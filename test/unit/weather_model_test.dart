import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clima_app2/app/models/weather_model/weather_model_extension.dart';

void main() {
  group('WeatherModel', () {
    test('fromJson deve converter corretamente', () {
      final json = {
        'name': 'Caratinga',
        'weather': [
          {'main': 'Clear', 'description': 'céu limpo', 'icon': '01d'},
        ],
        'main': {'temp': 25.5, 'humidity': 60, 'pressure': 1012},
        'wind': {'speed': 3.5},
      };

      final model = WeatherModel.fromJson(json);

      expect(model.city, 'Caratinga');
      expect(model.condition, 'Clear');
      expect(model.description, 'céu limpo');
      expect(model.icon, '01d');
      expect(model.temperature, 25.5);
      expect(model.humidity, 60);
      expect(model.pressure, 1012);
      expect(model.windSpeed, 3.5);
    });
  });
}
