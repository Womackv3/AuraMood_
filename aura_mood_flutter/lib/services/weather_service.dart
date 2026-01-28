import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  static bool _isRequesting = false;

  static Future<Map<String, dynamic>?> getCurrentWeather() async {
    if (_isRequesting) {
      debugPrint('Weather fetch already in progress, skipping...');
      return null;
    }
    _isRequesting = true;

    try {
      debugPrint('Checking location permission...');
      // Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Permission denied, requesting...');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permission denied after request');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permission permanently denied');
        return null;
      }

      debugPrint('Getting current position...');
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
      debugPrint('Position: ${position.latitude}, ${position.longitude}');

      // Fetch weather data from Open-Meteo (Fahrenheit)
      final url = Uri.parse(
        '$_baseUrl?latitude=${position.latitude}&longitude=${position.longitude}&current_weather=true&hourly=cloudcover,rain&temperature_unit=fahrenheit',
      );
      
      debugPrint('Fetching weather from API...');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        debugPrint('Weather API error: ${response.statusCode}');
        return null;
      }

      final data = json.decode(response.body);
      final currentWeather = data['current_weather'];
      final hourlyData = data['hourly'];

      // Get current hour index for hourly data
      final currentHour = DateTime.now().hour;
      
      debugPrint('Weather fetched successfully: ${currentWeather['temperature']}°F');

      return {
        'tempC': currentWeather['temperature']?.toDouble(),
        'cloudCoverPct': hourlyData['cloudcover']?[currentHour] as int?,
        'rainMm': hourlyData['rain']?[currentHour]?.toDouble(),
        'moonPhase': _calculateMoonPhase(DateTime.now()),
      };
    } catch (e) {
      debugPrint('Error fetching weather: $e');
      return null;
    } finally {
      _isRequesting = false;
    }
  }

  /// Fetch historical weather for a specific date/time using Open-Meteo archive API
  static Future<Map<String, dynamic>?> getHistoricalWeather(DateTime dateTime) async {
    if (_isRequesting) {
      debugPrint('Weather fetch already in progress (historical), skipping...');
      return null;
    }
    _isRequesting = true;

    try {
      debugPrint('Checking location permission (historical)...');
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Permission denied (historical), requesting...');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permission denied (historical)');
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final dateStr = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      final today = DateTime.now();
      final isToday = dateTime.year == today.year && dateTime.month == today.month && dateTime.day == today.day;

      // Use forecast API for today, archive API for past dates
      final String url;
      if (isToday) {
        url = '$_baseUrl?latitude=${position.latitude}&longitude=${position.longitude}&current_weather=true&hourly=cloudcover,rain&temperature_unit=fahrenheit';
      } else {
        url = 'https://archive-api.open-meteo.com/v1/archive?latitude=${position.latitude}&longitude=${position.longitude}&start_date=$dateStr&end_date=$dateStr&hourly=temperature_2m,cloudcover,rain&temperature_unit=fahrenheit';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final data = json.decode(response.body);
      final hour = dateTime.hour;

      if (isToday) {
        final currentWeather = data['current_weather'];
        final hourlyData = data['hourly'];
        return {
          'tempC': currentWeather['temperature']?.toDouble(),
          'cloudCoverPct': hourlyData['cloudcover']?[hour] as int?,
          'rainMm': hourlyData['rain']?[hour]?.toDouble(),
          'moonPhase': _calculateMoonPhase(dateTime),
        };
      } else {
        final hourlyData = data['hourly'];
        return {
          'tempC': (hourlyData['temperature_2m']?[hour] as num?)?.toDouble(),
          'cloudCoverPct': hourlyData['cloudcover']?[hour] as int?,
          'rainMm': (hourlyData['rain']?[hour] as num?)?.toDouble(),
          'moonPhase': _calculateMoonPhase(dateTime),
        };
      }
    } catch (e) {
      debugPrint('Error fetching historical weather: $e');
      return null;
    } finally {
      _isRequesting = false;
    }
  }

  /// Calculate moon phase based on date
  /// Uses a simplified algorithm based on the 29.53-day lunar cycle
  static String _calculateMoonPhase(DateTime date) {
    // Known new moon date: January 6, 2000
    final knownNewMoon = DateTime(2000, 1, 6);
    const lunarCycle = 29.53;

    final daysSinceNewMoon = date.difference(knownNewMoon).inDays;
    final daysIntoCycle = daysSinceNewMoon % lunarCycle;
    final phase = daysIntoCycle / lunarCycle;

    if (phase < 0.0625) return 'New Moon';
    if (phase < 0.1875) return 'Waxing Crescent';
    if (phase < 0.3125) return 'First Quarter';
    if (phase < 0.4375) return 'Waxing Gibbous';
    if (phase < 0.5625) return 'Full Moon';
    if (phase < 0.6875) return 'Waning Gibbous';
    if (phase < 0.8125) return 'Last Quarter';
    if (phase < 0.9375) return 'Waning Crescent';
    return 'New Moon';
  }

  /// Get weather icon based on conditions
  static String getWeatherIcon(int? cloudCoverPct, double? rainMm) {
    if (rainMm != null && rainMm > 0) {
      return '🌧️';
    }
    if (cloudCoverPct != null) {
      if (cloudCoverPct > 80) return '☁️';
      if (cloudCoverPct > 50) return '⛅';
      if (cloudCoverPct > 20) return '🌤️';
    }
    return '☀️';
  }

  /// Get moon phase emoji
  static String getMoonEmoji(String? phase) {
    switch (phase) {
      case 'New Moon':
        return '🌑';
      case 'Waxing Crescent':
        return '🌒';
      case 'First Quarter':
        return '🌓';
      case 'Waxing Gibbous':
        return '🌔';
      case 'Full Moon':
        return '🌕';
      case 'Waning Gibbous':
        return '🌖';
      case 'Last Quarter':
        return '🌗';
      case 'Waning Crescent':
        return '🌘';
      default:
        return '🌙';
    }
  }
}
