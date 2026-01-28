import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../services/weather_service.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

class WeatherDisplay extends ConsumerWidget {
  const WeatherDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return weatherAsync.when(
      loading: () => GlassContainer(
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
      ),
      error: (err, stack) => GlassContainer(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Weather unavailable. Tap to retry.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.accent),
              onPressed: () => ref.refresh(weatherProvider),
            ),
          ],
        ),
      ),
      data: (weather) {
        if (weather == null) return const SizedBox.shrink();

        final tempC = weather['tempC'] as double?;
        final cloudCoverPct = weather['cloudCoverPct'] as int?;
        final rainMm = weather['rainMm'] as double?;
        final moonPhase = weather['moonPhase'] as String?;

        final weatherIcon = WeatherService.getWeatherIcon(cloudCoverPct, rainMm);
        final moonIcon = WeatherService.getMoonEmoji(moonPhase);

        return GlassContainer(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Weather Icon + Temp
              Row(
                children: [
                  Text(weatherIcon, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  if (tempC != null)
                    Text(
                      '${tempC.round()}°F',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const Spacer(),
                  // Optional: Refresh button if user wants to force update
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18, color: AppColors.textMuted),
                    onPressed: () => ref.refresh(weatherProvider),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Row 2: Chips and Details
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (cloudCoverPct != null)
                      _WeatherChip(
                        icon: Icons.cloud_outlined,
                        label: '$cloudCoverPct%',
                      ),
                    if (cloudCoverPct != null) const SizedBox(width: 8),
                    _WeatherChip(
                      icon: Icons.water_drop_outlined,
                      label: rainMm != null ? '${rainMm.toStringAsFixed(1)}mm' : '0mm',
                    ),
                    const SizedBox(width: 16),
                    Text(moonIcon, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      moonPhase ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
