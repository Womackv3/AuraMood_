import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_service.dart';

final weatherProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  // Simple provider that fetches weather on read.
  // The UI can use .when() to handle loading/error states.
  // We can also use ref.listen or RefreshIndicator to trigger updates.
  return WeatherService.getCurrentWeather();
});
