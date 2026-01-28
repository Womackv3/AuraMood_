import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({super.key});

  @override
  State<WeatherDisplay> createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  Map<String, dynamic>? _weather;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weather = await WeatherService.getCurrentWeather();
      if (mounted) {
        setState(() {
          _weather = weather;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return GlassContainer(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(
              'Loading weather...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (_weather == null) {
      return const SizedBox.shrink();
    }

    final tempC = _weather!['tempC'] as double?;
    final cloudCoverPct = _weather!['cloudCoverPct'] as int?;
    final rainMm = _weather!['rainMm'] as double?;
    final moonPhase = _weather!['moonPhase'] as String?;

    final weatherIcon = WeatherService.getWeatherIcon(cloudCoverPct, rainMm);
    final moonIcon = WeatherService.getMoonEmoji(moonPhase);

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(weatherIcon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          if (tempC != null)
            Text(
              '${tempC.round()}°F',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          const SizedBox(width: 16),
          if (cloudCoverPct != null)
            _WeatherChip(
              icon: Icons.cloud_outlined,
              label: '$cloudCoverPct%',
            ),
          const SizedBox(width: 8),
          _WeatherChip(
            icon: Icons.water_drop_outlined,
            label: rainMm != null ? '${rainMm.toStringAsFixed(1)}mm' : '0mm',
          ),
          const Spacer(),
          Text(moonIcon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 6),
          Text(
            moonPhase ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _WeatherChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
