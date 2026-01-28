import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  bool _showAm = true;

  @override
  Widget build(BuildContext context) {
    final moodEntries = ref.watch(moodEntriesProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            title: Text(
              'ANALYTICS',
              style: TextStyle(
                letterSpacing: 4,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // AM/PM Toggle
                GlassContainer(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showAm = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _showAm ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'AM',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _showAm ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showAm = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_showAm ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'PM',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !_showAm ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Mood Trends Chart
                GlassContainer(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mood Trends',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last 3 months',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 300,
                        child: moodEntries.when(
                          data: (entries) {
                            final filteredEntries = entries.where((e) {
                              return _showAm ? e.timestamp.hour < 12 : e.timestamp.hour >= 12;
                            }).toList();

                            if (filteredEntries.isEmpty) {
                              return Center(
                                child: Text(
                                  'No data for ${_showAm ? "AM" : "PM"} entries',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              );
                            }

                            return FutureBuilder<Map<String, WeatherSnapshot>>(
                              future: ref.read(databaseProvider).getAllWeatherSnapshots(),
                              builder: (context, snapshot) {
                                return _MoodChart(
                                  entries: filteredEntries,
                                  weatherMap: snapshot.data ?? {},
                                );
                              },
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, s) => Center(child: Text('Error: $e')),
                        ),
                      ),
                    ],
                  ),
                ),

                // Legend
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Legend',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _LegendItem(color: AppColors.moodHigh, label: 'Mood Level'),
                      const SizedBox(height: 8),
                      _LegendItem(color: AppColors.warning, label: 'Anxiety Level'),
                      const SizedBox(height: 8),
                      _LegendItem(color: AppColors.error, label: 'Irritability Level'),
                      const SizedBox(height: 8),
                      _LegendItem(color: AppColors.secondary, label: 'Sleep Hours (bars)'),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodChart extends StatelessWidget {
  final List<dynamic> entries;
  final Map<String, WeatherSnapshot> weatherMap;

  const _MoodChart({required this.entries, required this.weatherMap});

  @override
  Widget build(BuildContext context) {
    final reversedEntries = entries.reversed.toList();
    final showDots = reversedEntries.length <= 10;
    final maxX = reversedEntries.length <= 1 ? 1.0 : (reversedEntries.length - 1).toDouble();

    // Mood line data
    final moodSpots = <FlSpot>[];
    final anxietySpots = <FlSpot>[];
    final irritabilitySpots = <FlSpot>[];
    final sleepBars = <BarChartGroupData>[];

    for (var i = 0; i < reversedEntries.length; i++) {
      final entry = reversedEntries[i];
      moodSpots.add(FlSpot(i.toDouble(), entry.moodLevel.toDouble()));

      if (entry.anxietyLevel != null) {
        anxietySpots.add(FlSpot(i.toDouble(), entry.anxietyLevel!.toDouble()));
      }

      if (entry.irritabilityLevel != null) {
        irritabilitySpots.add(FlSpot(i.toDouble(), entry.irritabilityLevel!.toDouble()));
      }

      if (entry.sleepHours != null) {
        sleepBars.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: entry.sleepHours!,
                color: AppColors.secondary.withValues(alpha: 0.25),
                width: reversedEntries.length <= 7 ? 20 : (reversedEntries.length <= 30 ? 10 : 6),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          ),
        );
      }
    }

    // Bottom axis interval
    final bottomInterval = reversedEntries.length <= 7
        ? 1.0
        : (reversedEntries.length / 5).ceilToDouble();

    return Stack(
      children: [
        // Bar chart for sleep (behind lines)
        if (sleepBars.isNotEmpty)
          BarChart(
            BarChartData(
              maxY: 12,
              minY: 0,
              barGroups: sleepBars,
              alignment: BarChartAlignment.center,
              groupsSpace: reversedEntries.length <= 7 ? 16 : 4,
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => AppColors.surface,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final idx = group.x;
                    if (idx < 0 || idx >= reversedEntries.length) return null;
                    final entry = reversedEntries[idx];
                    final sleep = entry.sleepHours;
                    if (sleep == null) return null;
                    return BarTooltipItem(
                      'Sleep: ${sleep.toStringAsFixed(1)}h',
                      const TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        // Line chart for mood metrics
        LineChart(
          LineChartData(
            minX: 0,
            maxX: maxX,
            minY: 0,
            maxY: 10,
            lineBarsData: [
              LineChartBarData(
                spots: moodSpots,
                isCurved: reversedEntries.length > 2,
                color: AppColors.moodHigh,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                    radius: showDots ? 5 : 0,
                    color: AppColors.moodHigh,
                    strokeWidth: 2,
                    strokeColor: AppColors.surface,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.moodHigh.withValues(alpha: 0.1),
                ),
              ),
              if (anxietySpots.isNotEmpty)
                LineChartBarData(
                  spots: anxietySpots,
                  isCurved: reversedEntries.length > 2,
                  color: AppColors.warning,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                      radius: showDots ? 4 : 0,
                      color: AppColors.warning,
                      strokeWidth: 2,
                      strokeColor: AppColors.surface,
                    ),
                  ),
                  dashArray: [5, 5],
                ),
              if (irritabilitySpots.isNotEmpty)
                LineChartBarData(
                  spots: irritabilitySpots,
                  isCurved: reversedEntries.length > 2,
                  color: AppColors.error,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                      radius: showDots ? 4 : 0,
                      color: AppColors.error,
                      strokeWidth: 2,
                      strokeColor: AppColors.surface,
                    ),
                  ),
                  dashArray: [5, 5],
                ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 2,
                  getTitlesWidget: (value, meta) {
                    if (value == meta.max || value == meta.min) {
                      return const SizedBox();
                    }
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: bottomInterval,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < reversedEntries.length) {
                      final date = reversedEntries[index].timestamp;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Text(
                            DateFormat('M/d').format(date),
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 2,
              getDrawingHorizontalLine: (value) => FlLine(
                color: AppColors.glassBorder,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => AppColors.surface,
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    if (index < 0 || index >= reversedEntries.length) {
                      return null;
                    }
                    final entry = reversedEntries[index];
                    final weather = weatherMap[entry.id];
                    final date = DateFormat('M/d h:mm a').format(entry.timestamp);

                    String label;
                    Color color;
                    switch (spot.barIndex) {
                      case 0:
                        label = 'Mood: ${spot.y.toInt()}';
                        color = AppColors.moodHigh;
                        break;
                      case 1:
                        label = 'Anxiety: ${spot.y.toInt()}';
                        color = AppColors.warning;
                        break;
                      case 2:
                        label = 'Irritability: ${spot.y.toInt()}';
                        color = AppColors.error;
                        break;
                      default:
                        label = '${spot.y.toInt()}';
                        color = Colors.white;
                    }

                    // Add weather + date info to the first line's tooltip
                    String weatherInfo = '';
                    if (spot.barIndex == 0) {
                      if (weather != null) {
                        final parts = <String>[];
                        if (weather.tempC != null) parts.add('${weather.tempC!.round()}°F');
                        if (weather.cloudCoverPct != null) parts.add('${weather.cloudCoverPct}% cloud');
                        parts.add('${weather.rainMm?.toStringAsFixed(1) ?? '0.0'}mm rain');
                        if (weather.moonPhase != null) parts.add(weather.moonPhase!);
                        weatherInfo = '\n$date\n${parts.join(' · ')}';
                      } else {
                        weatherInfo = '\n$date';
                      }
                    }

                    return LineTooltipItem(
                      '$label$weatherInfo',
                      TextStyle(
                        color: color,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
