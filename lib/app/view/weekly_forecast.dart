
import 'package:clima_app2/app/service/weekly.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyForecastWidget extends StatelessWidget {
  final List<DailyForecast> forecast;

  const WeeklyForecastWidget({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final day = forecast[index];
          return DailyForecastCard(forecast: day);
        },
      ),
    );
  }
}

class DailyForecastCard extends StatelessWidget {
  final DailyForecast forecast;

  const DailyForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            DateFormat('E').format(forecast.date), // Ex: "Seg"
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Image.network(
            'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
            width: 40,
          ),
          Text('${forecast.maxTemp.round()}°'),
          Text(
            '${forecast.precipitation > 0 ? '${(forecast.precipitation * 100).round()}%' : '0%'}',
            style: TextStyle(
              color: forecast.precipitation > 0.3 
                 ? Colors.red 
                 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}