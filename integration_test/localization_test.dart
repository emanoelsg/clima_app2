// integration_test/localization_test.dart
import 'package:clima_app2/app/controller/weather_controller.dart';
import 'package:clima_app2/app/core/utils/helpers/localization/localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
 testWidgets('Buscar clima por cidade inválida retorna erro tratado', (WidgetTester tester) async {
    final controller = WeatherController();

    await controller.fetchWeatherByCity('CidadeInexistente123');

    final clima = controller.weather.value;

    expect(clima, isNull); // ou verifique se erro foi tratado
  });


testWidgets('fetchWeatherByCity atualiza cidade corretamente', (tester) async {
  final controller = WeatherController();
  await controller.fetchWeatherByCity('São Paulo');

  expect(controller.weather.value?.name, isNotEmpty);
  expect(controller.city, 'São Paulo');
});
  testWidgets('getCurrentCity retorna cidade válida', (WidgetTester tester) async {
    final city = await getCurrentCity();

    expect(city, isNotNull);
    expect(city!.isNotEmpty, true);
    expect(city.contains(','), true);
  });
}