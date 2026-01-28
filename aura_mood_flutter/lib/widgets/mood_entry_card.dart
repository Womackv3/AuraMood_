import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/database.dart';
import '../providers/database_provider.dart';
import '../theme/app_theme.dart';
import '../services/weather_service.dart';
import 'glass_container.dart';
import 'mood_slider.dart';

class MoodEntryCard extends ConsumerStatefulWidget {
  const MoodEntryCard({super.key});

  @override
  ConsumerState<MoodEntryCard> createState() => _MoodEntryCardState();
}

class _MoodEntryCardState extends ConsumerState<MoodEntryCard> {
  int _moodLevel = 5;
  int _anxietyLevel = 5;
  int _irritabilityLevel = 5;
  double _sleepHours = 7;
  final _notesController = TextEditingController();
  bool _isSubmitting = false;
  bool _captureWeather = true;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get _isAm => DateTime.now().hour < 12;

  Future<void> _submitEntry() async {
    setState(() => _isSubmitting = true);

    try {
      final database = ref.read(databaseProvider);
      final now = DateTime.now();

      // Check if entry already exists for this period
      final existingEntry = await database.getMoodEntryForPeriod(now, _isAm);
      if (existingEntry != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You already have an entry for ${_isAm ? "AM" : "PM"} today'),
              backgroundColor: AppColors.warning,
            ),
          );
        }
        setState(() => _isSubmitting = false);
        return;
      }

      // Create mood entry
      await database.insertMoodEntry(
        MoodEntriesCompanion.insert(
          moodLevel: _moodLevel,
          anxietyLevel: Value(_anxietyLevel),
          irritabilityLevel: Value(_irritabilityLevel),
          sleepHours: Value(_sleepHours),
          notes: Value(_notesController.text.isEmpty ? null : _notesController.text),
        ),
      );

      // Capture weather if enabled
      if (_captureWeather) {
        try {
          final weather = await WeatherService.getCurrentWeather();
          if (weather != null) {
            final entries = await database.getAllMoodEntries(limit: 1);
            if (entries.isNotEmpty) {
              await database.insertWeatherSnapshot(
                WeatherSnapshotsCompanion.insert(
                  entryId: entries.first.id,
                  tempC: Value(weather['tempC']),
                  cloudCoverPct: Value(weather['cloudCoverPct']),
                  rainMm: Value(weather['rainMm']),
                  moonPhase: Value(weather['moonPhase']),
                ),
              );
            }
          }
        } catch (e) {
          debugPrint('Weather capture failed: $e');
        }
      }

      // Reset form
      setState(() {
        _moodLevel = 5;
        _anxietyLevel = 5;
        _irritabilityLevel = 5;
        _sleepHours = 7;
        _notesController.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mood entry saved!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving entry: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with period indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mood Check-in',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isAm ? AppColors.warning.withOpacity(0.2) : AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isAm ? AppColors.warning : AppColors.primary,
                  ),
                ),
                child: Text(
                  _isAm ? 'AM' : 'PM',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isAm ? AppColors.warning : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Mood Sliders Grid
          Row(
            children: [
              Expanded(
                child: MoodSlider(
                  label: 'Mood',
                  value: _moodLevel,
                  minColor: AppColors.moodLow,
                  maxColor: AppColors.moodHigh,
                  onChanged: (v) => setState(() => _moodLevel = v),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MoodSlider(
                  label: 'Anxiety',
                  value: _anxietyLevel,
                  minColor: AppColors.success,
                  maxColor: AppColors.warning,
                  onChanged: (v) => setState(() => _anxietyLevel = v),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: MoodSlider(
                  label: 'Irritability',
                  value: _irritabilityLevel,
                  minColor: AppColors.accent,
                  maxColor: AppColors.error,
                  onChanged: (v) => setState(() => _irritabilityLevel = v),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SleepSlider(
                  value: _sleepHours,
                  onChanged: (v) => setState(() => _sleepHours = v),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Notes TextField
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Add notes (optional)...',
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 16),

          // Weather toggle
          Row(
            children: [
              Switch(
                value: _captureWeather,
                onChanged: (v) => setState(() => _captureWeather = v),
                activeColor: AppColors.accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Capture weather data',
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.cloud_outlined,
                size: 16,
                color: _captureWeather ? AppColors.accent : AppColors.textMuted,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitEntry,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Entry'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _SleepSlider({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Sleep',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${value.toStringAsFixed(1)}h',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.lerp(AppColors.error, AppColors.success, value / 12),
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.secondary,
                  inactiveTrackColor: AppColors.glassBorder,
                  thumbColor: AppColors.secondary,
                  overlayColor: AppColors.secondary.withOpacity(0.2),
                ),
                child: Slider(
                  value: value,
                  min: 0,
                  max: 12,
                  divisions: 24,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
