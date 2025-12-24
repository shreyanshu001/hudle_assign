import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/weather_bloc.dart';
import 'blocs/theme_cubit.dart';
import 'repositories/weather_repository.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  // Initialize services
  final apiService = ApiService();
  final weatherRepository = WeatherRepository(
    apiService: apiService,
    storageService: storageService,
  );

  runApp(
    MyApp(weatherRepository: weatherRepository, storageService: storageService),
  );
}

class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository;
  final StorageService storageService;

  const MyApp({
    super.key,
    required this.weatherRepository,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(repository: weatherRepository),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(storageService: storageService),
        ),
        BlocProvider(
          create: (context) =>
              TemperatureUnitCubit(storageService: storageService),
        ),
        RepositoryProvider.value(value: weatherRepository),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: _lightTheme(),
            darkTheme: _darkTheme(),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
