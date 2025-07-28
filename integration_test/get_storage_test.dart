// integration_test/weather_controller_test.dart
import 'package:clima_app2/app/controller/weather_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:clima_app2/app/models/weather_model/weather_model.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Dados persistem entre sessões', (WidgetTester tester) async {
    await GetStorage.init();
    final controller = WeatherController();

    // Simula busca e salvamento
    await controller.fetchWeatherByCity('Belo Horizonte');
    controller.salvarClimaLocal();

    // Simula reinício do app
    final novoController = WeatherController();
    novoController.carregarClimaLocal();

    final clima = novoController.weather.value;

    expect(clima, isNotNull);
    expect(clima?.name?.toLowerCase(), contains('belo horizonte'));
  });

  testWidgets('WeatherController salva e carrega clima local corretamente', (WidgetTester tester) async {
    await GetStorage.init();
    final controller = WeatherController();

    // Preenche o weather com dados simulados
    controller.weather.value = WeatherModel(
      coord: Coord(lon: -42.0, lat: -19.0),
      weather: [
        Weather(
          id: 800,
          main: 'Clear',
          description: 'céu limpo',
          icon: '01d',
        ),
      ],
      base: 'stations',
      main: Main(
        temp: 25.0,
        feelsLike: 26.0,
        tempMin: 22.0,
        tempMax: 28.0,
        pressure: 1013,
        humidity: 60,
        seaLevel: 1013,
        grndLevel: 1000,
      ),
      visibility: 10000,
      wind: Wind(speed: 5.0, deg: 180, gust: 7.0),
      rain: Rain(the1H: 0.0),
      clouds: Clouds(all: 0),
      dt: 1690000000,
      sys: Sys(
        type: 1,
        id: 1234,
        country: 'BR',
        sunrise: 1690000000,
        sunset: 1690040000,
      ),
      timezone: -10800,
      id: 123456,
      name: 'Caratinga',
      cod: 200,
    );

    controller.salvarClimaLocal();

    // Limpa o estado atual para simular novo carregamento
    controller.weather.value = null;

    controller.carregarClimaLocal();

    final climaRecuperado = controller.weather.value;

    expect(climaRecuperado, isNotNull);
    expect(climaRecuperado?.name, 'Caratinga');
    expect(climaRecuperado?.main?.temp, 25.0);
    expect(climaRecuperado?.weather.first.icon, '01d');
    expect(climaRecuperado?.weather.first.description, 'céu limpo');
  });
}