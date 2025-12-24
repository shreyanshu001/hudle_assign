import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hudle_assign/blocs/weather_bloc.dart';
import 'package:hudle_assign/blocs/weather_event.dart';
import 'package:hudle_assign/blocs/weather_state.dart';
import 'package:hudle_assign/models/weather_model.dart';
import 'package:hudle_assign/repositories/weather_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late WeatherBloc weatherBloc;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    weatherBloc = WeatherBloc(repository: mockRepository);
  });

  tearDown(() {
    weatherBloc.close();
  });

  group('WeatherBloc', () {
    final mockWeather = WeatherModel(
      cityName: 'Delhi',
      temperature: 25.0,
      condition: 'Clear',
      description: 'clear sky',
      humidity: 60.0,
      windSpeed: 5.0,
      icon: '01d',
      timestamp: DateTime.now(),
    );

    test('initial state is WeatherInitial', () {
      expect(weatherBloc.state, const WeatherInitial());
    });

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherLoaded] when FetchWeatherByCity succeeds',
      build: () {
        when(
          () => mockRepository.getWeatherByCity('Delhi'),
        ).thenAnswer((_) async => mockWeather);
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const FetchWeatherByCity('Delhi')),
      expect: () => [const WeatherLoading(), WeatherLoaded(mockWeather)],
      verify: (_) {
        verify(() => mockRepository.getWeatherByCity('Delhi')).called(1);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherError] when FetchWeatherByCity fails',
      build: () {
        when(
          () => mockRepository.getWeatherByCity('InvalidCity'),
        ).thenThrow(Exception('City not found'));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const FetchWeatherByCity('InvalidCity')),
      expect: () => [
        const WeatherLoading(),
        const WeatherError('City not found'),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoaded] when LoadCachedWeather finds cached data',
      build: () {
        when(() => mockRepository.getCachedWeather()).thenReturn(mockWeather);
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const LoadCachedWeather()),
      expect: () => [WeatherLoaded(mockWeather)],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherInitial] when LoadCachedWeather finds no cached data',
      build: () {
        when(() => mockRepository.getCachedWeather()).thenReturn(null);
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const LoadCachedWeather()),
      expect: () => [const WeatherInitial()],
    );
  });
}
