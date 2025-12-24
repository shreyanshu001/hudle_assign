import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/weather_model.dart';
import '../blocs/theme_cubit.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TemperatureUnitCubit, String>(
      builder: (context, unit) {
        final temp = unit == 'celsius'
            ? weather.temperature
            : weather.temperatureInFahrenheit;
        final unitSymbol = unit == 'celsius' ? '°C' : '°F';

        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getGradientColors(weather.condition),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // City Name
                Text(
                  weather.cityName,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // Weather Icon
                Image.network(
                  'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.cloud,
                      size: 120,
                      color: Colors.white,
                    );
                  },
                ),

                // Temperature
                Text(
                  '${temp.toStringAsFixed(1)}$unitSymbol',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Condition
                Text(
                  weather.condition,
                  style: const TextStyle(fontSize: 24, color: Colors.white70),
                ),
                Text(
                  weather.description,
                  style: const TextStyle(fontSize: 16, color: Colors.white60),
                ),

                const SizedBox(height: 24),

                // Additional Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem(
                      Icons.water_drop,
                      '${weather.humidity.toStringAsFixed(0)}%',
                      'Humidity',
                    ),
                    _buildInfoItem(
                      Icons.air,
                      '${weather.windSpeed.toStringAsFixed(1)} m/s',
                      'Wind Speed',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }

  List<Color> _getGradientColors(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return [Colors.orange.shade400, Colors.deepOrange.shade600];
      case 'clouds':
        return [Colors.grey.shade600, Colors.blueGrey.shade800];
      case 'rain':
      case 'drizzle':
        return [Colors.blue.shade600, Colors.indigo.shade800];
      case 'thunderstorm':
        return [Colors.deepPurple.shade700, Colors.black87];
      case 'snow':
        return [Colors.lightBlue.shade300, Colors.blue.shade600];
      default:
        return [Colors.blue.shade400, Colors.purple.shade600];
    }
  }
}
