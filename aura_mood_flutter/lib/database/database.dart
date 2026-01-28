import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

part 'database.g.dart';

const _uuid = Uuid();

// Core Mood Entry
class MoodEntries extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  IntColumn get moodLevel => integer()();
  IntColumn get anxietyLevel => integer().nullable()();
  IntColumn get irritabilityLevel => integer().nullable()();
  RealColumn get sleepHours => real().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Medication Definitions
class Medications extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get name => text()();
  TextColumn get dosage => text().nullable()();
  TextColumn get scheduleTime => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Medication Logs (Adherence)
class MedLogs extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get medicationId => text().references(Medications, #id)();
  DateTimeColumn get scheduledFor => dateTime()();
  DateTimeColumn get takenAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// Environmental Context
class WeatherSnapshots extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get entryId => text().references(MoodEntries, #id)();
  RealColumn get tempC => real().nullable()();
  IntColumn get cloudCoverPct => integer().nullable()();
  RealColumn get rainMm => real().nullable()();
  TextColumn get moonPhase => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [MoodEntries, Medications, MedLogs, WeatherSnapshots])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Mood Entry queries
  Future<List<MoodEntry>> getAllMoodEntries({int limit = 180}) {
    return (select(moodEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();
  }

  Future<MoodEntry?> getMoodEntryForPeriod(DateTime date, bool isAm) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final periodStart = isAm ? startOfDay : startOfDay.add(const Duration(hours: 12));
    final periodEnd = periodStart.add(const Duration(hours: 12));

    return (select(moodEntries)
          ..where((t) => t.timestamp.isBiggerOrEqualValue(periodStart))
          ..where((t) => t.timestamp.isSmallerThanValue(periodEnd)))
        .getSingleOrNull();
  }

  Future<int> insertMoodEntry(MoodEntriesCompanion entry) {
    return into(moodEntries).insert(entry);
  }

  Future<bool> updateMoodEntry(MoodEntriesCompanion entry) {
    return (update(moodEntries)..where((t) => t.id.equals(entry.id.value)))
        .write(entry)
        .then((rows) => rows > 0);
  }

  Future<int> deleteMoodEntry(String id) {
    return (delete(moodEntries)..where((t) => t.id.equals(id))).go();
  }

  // Medication queries
  Future<List<Medication>> getAllMedications() {
    return select(medications).get();
  }

  Future<int> insertMedication(MedicationsCompanion medication) {
    return into(medications).insert(medication);
  }

  Future<bool> updateMedication(MedicationsCompanion medication) {
    return update(medications).replace(Medication(
      id: medication.id.value,
      name: medication.name.value,
      dosage: medication.dosage.value,
      scheduleTime: medication.scheduleTime.value,
    ));
  }

  Future<int> deleteMedication(String id) {
    return (delete(medications)..where((t) => t.id.equals(id))).go();
  }

  // Med Log queries
  Future<List<MedLog>> getMedLogsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(medLogs)
          ..where((t) => t.scheduledFor.isBiggerOrEqualValue(startOfDay))
          ..where((t) => t.scheduledFor.isSmallerThanValue(endOfDay)))
        .get();
  }

  Stream<List<MedLog>> watchMedLogsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(medLogs)
          ..where((t) => t.scheduledFor.isBiggerOrEqualValue(startOfDay))
          ..where((t) => t.scheduledFor.isSmallerThanValue(endOfDay)))
        .watch();
  }

  /// Get the latest log for a specific medication today
  Future<MedLog?> getLatestMedLogToday(String medicationId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(medLogs)
          ..where((t) => t.medicationId.equals(medicationId))
          ..where((t) => t.scheduledFor.isBiggerOrEqualValue(startOfDay))
          ..where((t) => t.scheduledFor.isSmallerThanValue(endOfDay))
          ..orderBy([(t) => OrderingTerm.desc(t.scheduledFor)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> insertMedLog(MedLogsCompanion log) {
    return into(medLogs).insert(log);
  }

  Future<bool> updateMedLogStatus(String id, String status, DateTime? takenAt) {
    return (update(medLogs)..where((t) => t.id.equals(id)))
        .write(MedLogsCompanion(
          status: Value(status),
          takenAt: Value(takenAt),
        ))
        .then((rows) => rows > 0);
  }

  // Weather snapshot queries
  Future<int> insertWeatherSnapshot(WeatherSnapshotsCompanion snapshot) {
    return into(weatherSnapshots).insert(snapshot);
  }

  Future<WeatherSnapshot?> getWeatherForEntry(String entryId) {
    return (select(weatherSnapshots)..where((t) => t.entryId.equals(entryId)))
        .getSingleOrNull();
  }

  Future<Map<String, WeatherSnapshot>> getAllWeatherSnapshots() async {
    final snapshots = await select(weatherSnapshots).get();
    return {for (final s in snapshots) s.entryId: s};
  }

  Stream<List<MoodEntry>> watchRecentMoodEntries({int limit = 30}) {
    return (select(moodEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .watch();
  }

  Stream<List<Medication>> watchAllMedications() {
    return select(medications).watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'aura_mood.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
