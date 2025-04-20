import 'package:clima_app2/app/service/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherDetails extends StatefulWidget {
  final WeatherModel weatherData;

  const WeatherDetails({super.key, required this.weatherData});

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  @override
  Widget build(BuildContext context) {
    final condition = widget.weatherData.weather.firstOrNull;
    final main = widget.weatherData.main;
    final sys = widget.weatherData.sys;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeaderCard(main, widget.weatherData.name, sys?.country),
          const SizedBox(height: 20),
          _buildConditionCard(condition, main?.feelsLike),

          const SizedBox(height: 20),

          _buildDetailsGrid(main, widget.weatherData.wind, widget.weatherData.clouds),

          const SizedBox(height: 20),
          _buildSunCard(sys),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(Main? main, String? city, String? country) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              city ?? '--',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (country != null) Text(country),
            const SizedBox(height: 8),
            Text(
              '${main?.temp?.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
            ),
            Text(
              'Mín: ${main?.tempMin?.toStringAsFixed(1)}°C / Máx: ${main?.tempMax?.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionCard(Weather? condition, double? feelsLike) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (condition?.icon != null)
              Image.network(
                'https://openweathermap.org/img/wn/${condition!.icon}@4x.png',
                width: 100,
                height: 105,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    condition?.main?.toUpperCase() ?? '--',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    condition?.description ?? '--',
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (feelsLike != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Sensação: ${feelsLike.toStringAsFixed(1)}°C',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(Main? main, dynamic wind, Clouds? clouds) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
    
      children: [
        _buildDetailItem(
          'Umidade',
          '${main?.humidity}%',
          Icons.water_drop,
          Colors.blue,
        ),
        _buildDetailItem(
          'Pressão',
          '${main?.pressure} hPa',
          Icons.compress,
          Colors.deepPurple,
        ),
        _buildDetailItem('Vento', '${wind?.speed} m/s', Icons.air, Colors.teal),
        _buildDetailItem('Nuvens', '${clouds?.all}%', Icons.cloud, Colors.grey),
      ],
    );
  }

  Widget _buildSunCard(Sys? sys) {
    final sunriseTime =
        sys?.sunrise != null
            ? DateTime.fromMillisecondsSinceEpoch(sys!.sunrise! * 1000)
            : null;
    final sunsetTime =
        sys?.sunset != null
            ? DateTime.fromMillisecondsSinceEpoch(sys!.sunset! * 1000)
            : null;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSunTime('Nascer do Sol', sunriseTime, Icons.wb_sunny),
            _buildSunTime('Pôr do Sol', sunsetTime, Icons.nightlight),
          ],
        ),
      ),
    );
  }

  // ========== WIDGETS AUXILIARES ========== //
  Widget _buildDetailItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14)),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSunTime(String label, DateTime? time, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.amber),
        const SizedBox(height: 8),
        Text(label),
        Text(
          time != null ? DateFormat('HH:mm').format(time) : '--',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
