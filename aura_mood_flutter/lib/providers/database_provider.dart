import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

// Mood entries stream provider
final moodEntriesProvider = StreamProvider<List<MoodEntry>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchRecentMoodEntries(limit: 180);
});

// Medications stream provider
final medicationsProvider = StreamProvider<List<Medication>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchAllMedications();
});

// Today's med logs as a stream (reacts to changes)
final todayMedLogsProvider = StreamProvider<List<MedLog>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchMedLogsForDate(DateTime.now());
});
