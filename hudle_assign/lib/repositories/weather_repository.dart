import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class WeatherRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  WeatherRepository({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;

  Future<WeatherModel> getWeatherByCity(String cityName) async {
    try {
      final data = await _apiService.getWeatherByCity(cityName);
      final weather = WeatherModel.fromJson(data);

      // Caching weather data
      await _storageService.cacheWeatherData(weather);

      // Save to search history
      await _storageService.addToSearchHistory(cityName);

      // Saved as last searched
      await _storageService.saveLastSearchedCity(cityName);

      return weather;
    } catch (e) {
      rethrow;
    }
  }

  WeatherModel? getCachedWeather() {
    return _storageService.getCachedWeatherData();
  }

  String? getLastSearchedCity() {
    return _storageService.getLastSearchedCity();
  }

  List<String> getSearchHistory() {
    return _storageService.getSearchHistory();
  }

  Future<void> clearSearchHistory() async {
    await _storageService.clearSearchHistory();
  }
}
