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
    final wind = widget.weatherData.wind;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Cabeçalho com efeito parallax
          SliverAppBar(
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _getBackgroundImage(condition?.main ?? ''),
                    fit: BoxFit.cover,
                    color: const Color.fromARGB(902, 0, 0, 0),
                    colorBlendMode: BlendMode.darken,
                  ),
                  _buildHeaderContent(main, condition, widget.weatherData.name),
                ],
              ),
            ),
          ),

          // Corpo principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Cards de status rápido
                  _buildQuickStatsRow(main, wind, sys),
                  const SizedBox(height: 24),

                  // Previsão horária (simulada)
                  _buildHourlyForecast(),
                  const SizedBox(height: 24),

                  // Detalhes expandidos
                  _buildDetailCards(main, wind, sys, condition),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getBackgroundImage(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'rain':
        return 'assets/images/rain_bg.jpg';
      case 'clouds':
        return 'assets/images/clouds_bg.jpg';
      case 'snow':
        return 'assets/images/snow_bg.jpg';
      default:
        return 'assets/images/sunny_bg.jpg';
    }
  }

  Widget _buildHeaderContent(Main? main, Weather? condition, String? city) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            city ?? '--',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat('EEEE, d MMMM').format(DateTime.now()),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${main?.temp?.toStringAsFixed(1)}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (condition?.icon != null)
                    Image.network(
                      'https://openweathermap.org/img/wn/${condition!.icon}@2x.png',
                      width: 60,
                      color: Colors.white,
                    ),
                  Text(
                    condition?.description?.toUpperCase() ?? '--',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsRow(Main? main, Wind? wind, Sys? sys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuickStat('Máx', '${main?.tempMax?.toStringAsFixed(1)}°', Icons.arrow_upward),
        _buildQuickStat('Mín', '${main?.tempMin?.toStringAsFixed(1)}°', Icons.arrow_downward),
        _buildQuickStat('Vento', '${wind?.speed?.toStringAsFixed(1)} m/s', Icons.air),
        _buildQuickStat('Umidade', '${main?.humidity}%', Icons.water_drop),
      ],
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    // Simulação de dados horários (substitua pelos seus dados reais)
    final hours = List.generate(24, (i) => i);
    
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hours.length,
        itemBuilder: (context, index) {
          final hour = hours[index];
          return Container(
            width: 60,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: hour == DateTime.now().hour 
                 
                  ? Colors.blue
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${hour}h'),
                const Icon(Icons.wb_sunny, size: 24),
                Text('${20 + (index % 5)}°'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCards(Main? main, Wind? wind, Sys? sys, Weather? condition) {
    return Column(
      children: [
        // Card de sensação térmica
        _buildDetailCard(
          icon: Icons.thermostat,
          title: 'Sensação Térmica',
          value: '${main?.feelsLike?.toStringAsFixed(1)}°C',
          color: Colors.orange.shade100,
        ),
        
        // Card de vento
        _buildDetailCard(
          icon: Icons.air,
          title: 'Vento',
          value: '${wind?.speed?.toStringAsFixed(1)} m/s',
          color: Colors.blue.shade100,
        ),
        
        // Card de nascer/pôr do sol
        _buildSunsetSunriseCard(sys),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget _buildSunsetSunriseCard(Sys? sys) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSunTime('Nascer do Sol', sys?.sunrise, Icons.wb_sunny),
            Container(height: 30, width: 1, color: Colors.grey.shade300),
            _buildSunTime('Pôr do Sol', sys?.sunset, Icons.nightlight),
          ],
        ),
      ),
    );
  }

  Widget _buildSunTime(String label, int? timestamp, IconData icon) {
    final time = timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
        : null;
    
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.amber),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(
          time != null ? DateFormat('HH:mm').format(time) : '--',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}