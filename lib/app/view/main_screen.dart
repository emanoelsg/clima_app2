import 'package:clima_app2/app/controller/api_controller.dart';
import 'package:clima_app2/app/view/weather_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Consumer<WeatherController>(
                builder: (context, value, child) {
                  if (value.isLoading == true) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (value.error != null) {
                    return Center(child: Text(value.error.toString()));
                  }
                  if (value.weather == null) {
                    return Center(
                      child: Text('Não foi possível carregar dados'),
                    );
                  }
                  return WeatherDetails(weatherDetails: value.weather);
                  }
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<WeatherController>().fetchWeather(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
