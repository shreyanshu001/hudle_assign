import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/weather_bloc.dart';
import '../blocs/weather_event.dart';
import '../blocs/weather_state.dart';
import '../blocs/theme_cubit.dart';
import '../widgets/weather_card.dart';
import '../widgets/error_widget.dart';
import '../repositories/weather_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    // Load cached weather on starting
    context.read<WeatherBloc>().add(const LoadCachedWeather());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchWeather() {
    final city = _searchController.text.trim();
    if (city.isNotEmpty) {
      context.read<WeatherBloc>().add(FetchWeatherByCity(city));
      _searchController.clear();
      FocusScope.of(context).unfocus();
      setState(() => _showHistory = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Temperature Unit Toggle
          BlocBuilder<TemperatureUnitCubit, String>(
            builder: (context, unit) {
              return IconButton(
                icon: Text(
                  unit == 'celsius' ? '°C' : '°F',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tooltip: 'Toggle Temperature Unit',
                onPressed: () {
                  context.read<TemperatureUnitCubit>().toggleUnit();
                },
              );
            },
          ),
          // Theme Toggle
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return IconButton(
                icon: Icon(
                  mode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
                ),
                tooltip: 'Toggle Theme',
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<WeatherBloc>().add(const RefreshWeather());
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                _buildSearchBar(),
                const SizedBox(height: 16),

                // Search History
                if (_showHistory) _buildSearchHistory(),

                BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is WeatherLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(64.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is WeatherLoaded) {
                      return Column(
                        children: [
                          WeatherCard(weather: state.weather),
                          const SizedBox(height: 16),
                          Text(
                            'Last updated: ${_formatTime(state.weather.timestamp)}',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      );
                    } else if (state is WeatherError) {
                      return ErrorDisplay(
                        message: state.message,
                        onRetry: () {
                          final lastCity = context
                              .read<WeatherRepository>()
                              .getLastSearchedCity();
                          if (lastCity != null) {
                            context.read<WeatherBloc>().add(
                              FetchWeatherByCity(lastCity),
                            );
                          }
                        },
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(64.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.cloud_outlined,
                                size: 100,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Search for a city to get started!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Enter city name...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  setState(() => _showHistory = !_showHistory);
                },
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _searchWeather,
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
        onSubmitted: (_) => _searchWeather(),
        textInputAction: TextInputAction.search,
      ),
    );
  }

  Widget _buildSearchHistory() {
    final history = context.read<WeatherRepository>().getSearchHistory();

    if (history.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No search history yet'),
        ),
      );
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    context.read<WeatherRepository>().clearSearchHistory();
                    setState(() {});
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(history[index]),
                onTap: () {
                  context.read<WeatherBloc>().add(
                    FetchWeatherByCity(history[index]),
                  );
                  setState(() => _showHistory = false);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
