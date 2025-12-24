import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final String cityName;
  final double temperature;
  final String condition;
  final String description;
  final double humidity;
  final double windSpeed;
  final String icon;
  final DateTime timestamp;

  const WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.timestamp,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      humidity: (json['main']['humidity'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      icon: json['weather'][0]['icon'] ?? '',
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'main': {'temp': temperature, 'humidity': humidity},
      'weather': [
        {'main': condition, 'description': description, 'icon': icon},
      ],
      'wind': {'speed': windSpeed},
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Convert Celsius to Fahrenheit
  double get temperatureInFahrenheit => (temperature * 9 / 5) + 32;

  @override
  List<Object?> get props => [
    cityName,
    temperature,
    condition,
    description,
    humidity,
    windSpeed,
    icon,
    timestamp,
  ];
}
