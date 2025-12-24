import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static final String apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  static const String lastSearchedCity = 'last_searched_city';
  static const String searchHistory = 'search_history';
  static const String cachedWeatherData = 'cached_weather_data';
  static const String isDarkMode = 'is_dark_mode';
  static const String temperatureUnit = 'temperature_unit';
}
