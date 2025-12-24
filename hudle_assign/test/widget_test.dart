// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hudle_assign/main.dart';
import 'package:hudle_assign/repositories/weather_repository.dart';
import 'package:hudle_assign/services/api_service.dart';
import 'package:hudle_assign/services/storage_service.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final storageService = StorageService();
    await storageService.init();

    // Initialize services
    final apiService = ApiService();
    final weatherRepository = WeatherRepository(
      apiService: apiService,
      storageService: storageService,
    );
    await tester.pumpWidget(
      MyApp(
        weatherRepository: weatherRepository,
        storageService: storageService,
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
