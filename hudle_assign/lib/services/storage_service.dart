import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/weather_model.dart';

class StorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save last searched city
  Future<void> saveLastSearchedCity(String cityName) async {
    await _prefs.setString(AppConstants.lastSearchedCity, cityName);
  }

  // Get last searched city
  String? getLastSearchedCity() {
    return _prefs.getString(AppConstants.lastSearchedCity);
  }

  // Save search history
  Future<void> addToSearchHistory(String cityName) async {
    List<String> history = getSearchHistory();

    // Remove if already exists
    history.remove(cityName);

    // Add to beginning
    history.insert(0, cityName);

    // Keep only last 10 searches
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }

    await _prefs.setStringList(AppConstants.searchHistory, history);
  }

  // Get search history
  List<String> getSearchHistory() {
    return _prefs.getStringList(AppConstants.searchHistory) ?? [];
  }

  // Clear search history
  Future<void> clearSearchHistory() async {
    await _prefs.remove(AppConstants.searchHistory);
  }

  // Cache weather data
  Future<void> cacheWeatherData(WeatherModel weather) async {
    final jsonString = jsonEncode(weather.toJson());
    await _prefs.setString(AppConstants.cachedWeatherData, jsonString);
  }

  // Get cached weather data
  WeatherModel? getCachedWeatherData() {
    final jsonString = _prefs.getString(AppConstants.cachedWeatherData);
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString);
        return WeatherModel.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Dark mode
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(AppConstants.isDarkMode, isDark);
  }

  bool isDarkMode() {
    return _prefs.getBool(AppConstants.isDarkMode) ?? false;
  }

  // Temperature unit
  Future<void> setTemperatureUnit(String unit) async {
    await _prefs.setString(AppConstants.temperatureUnit, unit);
  }

  String getTemperatureUnit() {
    return _prefs.getString(AppConstants.temperatureUnit) ?? 'celsius';
  }
}
