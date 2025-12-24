import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import '../repositories/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _repository;

  WeatherBloc({required WeatherRepository repository})
    : _repository = repository,
      super(const WeatherInitial()) {
    on<FetchWeatherByCity>(_onFetchWeatherByCity);
    on<LoadCachedWeather>(_onLoadCachedWeather);
    on<RefreshWeather>(_onRefreshWeather);
  }

  Future<void> _onFetchWeatherByCity(
    FetchWeatherByCity event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());

    try {
      final weather = await _repository.getWeatherByCity(event.cityName);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadCachedWeather(
    LoadCachedWeather event,
    Emitter<WeatherState> emit,
  ) async {
    final cachedWeather = _repository.getCachedWeather();

    if (cachedWeather != null) {
      emit(WeatherLoaded(cachedWeather));
    } else {
      emit(const WeatherInitial());
    }
  }

  Future<void> _onRefreshWeather(
    RefreshWeather event,
    Emitter<WeatherState> emit,
  ) async {
    if (state is WeatherLoaded) {
      final currentWeather = (state as WeatherLoaded).weather;

      try {
        final weather = await _repository.getWeatherByCity(
          currentWeather.cityName,
        );
        emit(WeatherLoaded(weather));
      } catch (e) {
        //if refresh fails
        emit(WeatherError(e.toString().replaceAll('Exception: ', '')));
        emit(WeatherLoaded(currentWeather));
      }
    }
  }
}
