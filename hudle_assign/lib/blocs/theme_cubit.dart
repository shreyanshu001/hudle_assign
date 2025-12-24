import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/storage_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final StorageService _storageService;

  ThemeCubit({required StorageService storageService})
    : _storageService = storageService,
      super(storageService.isDarkMode() ? ThemeMode.dark : ThemeMode.light);

  void toggleTheme() {
    final newTheme = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _storageService.setDarkMode(newTheme == ThemeMode.dark);
    emit(newTheme);
  }
}

class TemperatureUnitCubit extends Cubit<String> {
  final StorageService _storageService;

  TemperatureUnitCubit({required StorageService storageService})
    : _storageService = storageService,
      super(storageService.getTemperatureUnit());

  void toggleUnit() {
    final newUnit = state == 'celsius' ? 'fahrenheit' : 'celsius';
    _storageService.setTemperatureUnit(newUnit);
    emit(newUnit);
  }
}
