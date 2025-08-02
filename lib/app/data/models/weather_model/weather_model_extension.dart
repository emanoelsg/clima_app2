// app/data/models/weather_model/weather_model_extension.dart
import 'weather_model.dart';

extension WeatherModelExtension on WeatherModel {
  String get icon =>
      (weather.isNotEmpty) ? weather.first.icon ?? '01d' : '01d';

  String get description =>
      (weather.isNotEmpty) ? weather.first.description ?? '' : '';

  String get condition =>
      (weather.isNotEmpty) ? weather.first.main ?? 'clear' : 'clear';

  double get temperature => main?.temp ?? 0.0;

  int get humidity => main?.humidity ?? 0;

  int get pressure => main?.pressure ?? 0;

  double get windSpeed => wind?.speed ?? 0.0;

  String get city => name ?? 'Cidade';
}