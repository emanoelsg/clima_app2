import 'package:clima_app2/app/controller/api_controller.dart';
import 'package:clima_app2/app/service/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherDetails extends StatefulWidget {
  const WeatherDetails({super.key});

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WeatherController>();
    final weather = controller.weather;

    return Scaffold(
      appBar: AppBar(
        title: Text('Clima App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: _buildBody(controller, weather),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.fetchWeather(),
        tooltip: 'Atualizar',
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody(WeatherController controller, WeatherModel? weather) {
    if (controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (controller.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 50),
            SizedBox(height: 16),
            Text('Erro: ${controller.error}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.fetchWeather(),
              child: Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (weather == null) {
      return Center(
        child: Text('Toque no botão de busca para começar'),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Cabeçalho com localização e temperatura
          _buildWeatherHeader(weather),
          SizedBox(height: 24),
          
          // Condição atual
          _buildCurrentCondition(weather),
          SizedBox(height: 24),
          
          // Detalhes em grid
          _buildWeatherDetails(weather),
        ],
      ),
    );
  }

  Widget _buildWeatherHeader(WeatherModel weather) {
    return Column(
      children: [
        Text(
          weather.name ?? '--',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          '${weather.main?.temp?.toStringAsFixed(1) ?? '--'}°C',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget _buildCurrentCondition(WeatherModel weather) {
    final condition = weather.weather.firstOrNull;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            if (condition?.icon != null)
              Image.network(
                'https://openweathermap.org/img/wn/${condition!.icon}@2x.png',
                width: 80,
                height: 80,
              ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                condition?.description?.toUpperCase() ?? '--',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetails(WeatherModel weather) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: [
        _buildDetailCard(
          icon: Icons.water_drop,
          title: 'Umidade',
          value: '${weather.main?.humidity ?? '--'}%',
        ),
       
        _buildDetailCard(
          icon: Icons.thermostat,
          title: 'Sensação',
          value: '${weather.main?.feelsLike?.toStringAsFixed(1) ?? '--'}°C',
        ),
        _buildDetailCard(
          icon: Icons.compress,
          title: 'Pressão',
          value: '${weather.main?.pressure ?? '--'} hPa',
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 14)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buscar Cidade'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Ex: São Paulo,BR'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<WeatherController>().fetchWeather(city: controller.text);
              Navigator.pop(context);
            },
            child: Text('Buscar'),
          ),
        ],
      ),
    );
  }
}


