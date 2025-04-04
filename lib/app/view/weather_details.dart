import 'package:clima_app2/app/service/models.dart';
import 'package:flutter/material.dart';

class WeatherDetails extends StatefulWidget {
  final WeatherModel? weatherDetails;

  const WeatherDetails({required this.weatherDetails, super.key});

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  @override
  Widget build(BuildContext context) {
    // Extrai e formata os dados com fallbacks seguros
    final temp = widget.weatherDetails?.main?.temp?.toStringAsFixed(1) ?? '--';
    final humidity = widget.weatherDetails?.main?.humidity?.toString() ?? '--';
    final condition =
        widget.weatherDetails?.weather.firstOrNull?.description ??
        'Condição não disponível';

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Card de temperatura principal
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$temp°C',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                condition.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                childAspectRatio: 1.7,
                                padding: EdgeInsets.zero,
                                children: [
                                  _buildWeatherInfoItem(
                                    icon: Icons.water_drop,
                                    label: 'UMIDADE',
                                    value: '$humidity%',
                                    iconColor: Colors.lightBlue,
                                  ),

                                  _buildWeatherInfoItem(
                                    icon: Icons.thermostat,
                                    label: 'MÍNIMA',
                                    value:
                                        '${widget.weatherDetails?.main?.tempMin?.toStringAsFixed(1) ?? '--'}°C',
                                    iconColor: Colors.blueAccent,
                                  ),
                                  _buildWeatherInfoItem(
                                    icon: Icons.thermostat,
                                    label: 'MÁXIMA',
                                    value:
                                        '${widget.weatherDetails?.main?.tempMax?.toStringAsFixed(1) ?? '--'}°C',
                                    iconColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Grade de informações meteorológicas
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget reutilizável para itens de informação
  Widget _buildWeatherInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Color iconColor = Colors.blueGrey,
  }) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: iconColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
