// test/lib/app/controllers/weather_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/controller/weather_controller.dart';
import 'package:clima_app2/app/models/weather_model/weather_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  group('WeatherController - Unit Tests com modelo completo', () {
    late WeatherController controller;

    setUp(() {
      controller = WeatherController();
    });

  
    test('testCity altera _currentCity corretamente', () {
      controller.testCity = 'Belo Horizonte';
      expect(controller.city, 'Belo Horizonte');
    });
  });
}