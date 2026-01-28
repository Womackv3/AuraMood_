import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';
import '../services/weather_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';

class LogsPage extends ConsumerWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodEntries = ref.watch(moodEntriesProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: false,
            backgroundColor: Colors.transparent,
            title: Text(
              'MOOD LOGS',
              style: TextStyle(
                letterSpacing: 4,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: moodEntries.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return SliverToBoxAdapter(
                    child: GlassContainer(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mood_outlined,
                              size: 64,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No mood entries yet',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start tracking your mood from the Dashboard',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = entries[index];
                      return _MoodLogCard(entry: entry);
                    },
                    childCount: entries.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $error')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodLogCard extends ConsumerWidget {
  final MoodEntry entry;

  const _MoodLogCard({required this.entry});

  Color _getMoodColor(int level) {
    if (level <= 3) return AppColors.moodLow;
    if (level <= 6) return AppColors.moodMid;
    return AppColors.moodHigh;
  }

  String _getPeriod(DateTime timestamp) {
    return timestamp.hour < 12 ? 'AM' : 'PM';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error, size: 28),
      ),
      confirmDismiss: (_) => _confirmDelete(context, ref),
      child: GlassContainer(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat.format(entry.timestamp),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${timeFormat.format(entry.timestamp)} (${_getPeriod(entry.timestamp)})',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _showEditDialog(context, ref),
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: AppColors.textMuted,
                      tooltip: 'Edit',
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getMoodColor(entry.moodLevel).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getMoodColor(entry.moodLevel),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '${entry.moodLevel}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getMoodColor(entry.moodLevel),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (entry.anxietyLevel != null)
                  _MetricChip(
                    label: 'Anxiety',
                    value: entry.anxietyLevel!,
                    color: AppColors.warning,
                  ),
                if (entry.irritabilityLevel != null)
                  _MetricChip(
                    label: 'Irritability',
                    value: entry.irritabilityLevel!,
                    color: AppColors.error,
                  ),
                if (entry.sleepHours != null)
                  _MetricChip(
                    label: 'Sleep',
                    value: entry.sleepHours!.toInt(),
                    suffix: 'h',
                    color: AppColors.secondary,
                  ),
              ],
            ),
            // Weather data
            FutureBuilder<WeatherSnapshot?>(
              future: ref.read(databaseProvider).getWeatherForEntry(entry.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox.shrink();
                }
                final weather = snapshot.data!;
                final parts = <String>[];
                if (weather.tempC != null) parts.add('${weather.tempC!.round()}°F');
                if (weather.cloudCoverPct != null) parts.add('${weather.cloudCoverPct}% cloud');
                parts.add('${weather.rainMm?.toStringAsFixed(1) ?? '0.0'}mm rain');
                if (weather.moonPhase != null) parts.add(weather.moonPhase!);

                if (parts.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_outlined, size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          parts.join(' · '),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (entry.notes != null && entry.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                entry.notes!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Entry?'),
        content: const Text('This mood entry will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final database = ref.read(databaseProvider);
      await database.deleteMoodEntry(entry.id);
      return true;
    }
    return false;
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    int mood = entry.moodLevel;
    int? anxiety = entry.anxietyLevel;
    int? irritability = entry.irritabilityLevel;
    double? sleep = entry.sleepHours;
    final notesController = TextEditingController(text: entry.notes ?? '');
    bool isSyncingWeather = false;
    String? weatherStatus;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Edit Entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _EditSlider(
                  label: 'Mood',
                  value: mood,
                  color: AppColors.moodHigh,
                  onChanged: (v) => setDialogState(() => mood = v),
                ),
                _EditSlider(
                  label: 'Anxiety',
                  value: anxiety ?? 5,
                  color: AppColors.warning,
                  onChanged: (v) => setDialogState(() => anxiety = v),
                ),
                _EditSlider(
                  label: 'Irritability',
                  value: irritability ?? 5,
                  color: AppColors.error,
                  onChanged: (v) => setDialogState(() => irritability = v),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Sleep: '),
                    Expanded(
                      child: Slider(
                        value: (sleep ?? 7).clamp(0, 12),
                        min: 0,
                        max: 12,
                        divisions: 24,
                        label: '${(sleep ?? 7).toStringAsFixed(1)}h',
                        activeColor: AppColors.secondary,
                        onChanged: (v) => setDialogState(() => sleep = v),
                      ),
                    ),
                    Text('${(sleep ?? 7).toStringAsFixed(1)}h'),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'How are you feeling?',
                  ),
                  maxLines: 3,
                ),
                const Divider(height: 24, color: AppColors.glassBorder),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: isSyncingWeather
                        ? null
                        : () async {
                            setDialogState(() {
                              isSyncingWeather = true;
                              weatherStatus = null;
                            });
                            try {
                              final weather = await WeatherService.getHistoricalWeather(entry.timestamp);
                              if (weather != null) {
                                final database = ref.read(databaseProvider);
                                // Check if weather already exists for this entry
                                final existing = await database.getWeatherForEntry(entry.id);
                                if (existing != null) {
                                  // Delete old and insert new
                                  await (database.delete(database.weatherSnapshots)
                                        ..where((t) => t.entryId.equals(entry.id)))
                                      .go();
                                }
                                await database.insertWeatherSnapshot(
                                  WeatherSnapshotsCompanion.insert(
                                    entryId: entry.id,
                                    tempC: Value(weather['tempC']),
                                    cloudCoverPct: Value(weather['cloudCoverPct']),
                                    rainMm: Value(weather['rainMm']),
                                    moonPhase: Value(weather['moonPhase']),
                                  ),
                                );
                                setDialogState(() => weatherStatus = 'Weather synced!');
                              } else {
                                setDialogState(() => weatherStatus = 'Could not fetch weather');
                              }
                            } catch (e) {
                              setDialogState(() => weatherStatus = 'Error: $e');
                            } finally {
                              setDialogState(() => isSyncingWeather = false);
                            }
                          },
                    icon: isSyncingWeather
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cloud_sync_outlined),
                    label: Text(isSyncingWeather ? 'Syncing...' : 'Sync Weather'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent),
                    ),
                  ),
                ),
                if (weatherStatus != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      weatherStatus!,
                      style: TextStyle(
                        fontSize: 12,
                        color: weatherStatus == 'Weather synced!'
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final database = ref.read(databaseProvider);
                await database.updateMoodEntry(
                  MoodEntriesCompanion(
                    id: Value(entry.id),
                    timestamp: Value(entry.timestamp),
                    moodLevel: Value(mood),
                    anxietyLevel: Value(anxiety),
                    irritabilityLevel: Value(irritability),
                    sleepHours: Value(sleep),
                    notes: Value(notesController.text.trim().isEmpty
                        ? null
                        : notesController.text.trim()),
                  ),
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditSlider extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final ValueChanged<int> onChanged;

  const _EditSlider({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: TextStyle(color: color)),
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: '$value',
            activeColor: color,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        SizedBox(
          width: 24,
          child: Text(
            '$value',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final int value;
  final String? suffix;
  final Color color;

  const _MetricChip({
    required this.label,
    required this.value,
    this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$value${suffix ?? ''}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
