import 'package:clima_app2/app/controller/api_controller.dart';
import 'package:clima_app2/app/service/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherDetails extends StatelessWidget {
  final WeatherModel? weatherDetails;


  WeatherDetails({required this.weatherDetails, super.key});
    late  final temp = weatherDetails?.main?.temp;
    late final tempString = temp?.toStringAsFixed(1)?? 'N/D';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<WeatherController>(
          builder:
              (BuildContext context, WeatherController value, Widget? child) {
                return Column(
                  children: [
                    Text(tempString)
                  ],
                );
              },
        ),
      ),
    );
  }
}
