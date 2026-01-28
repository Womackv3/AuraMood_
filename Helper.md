# Helper.md - Aura Mood (Flutter Edition)

## 1. Project Identity: "Aura Mood"

**Vibe Concept**: Dark-mode by default, biometric-focused, glassmorphism UI. Unlike standard trackers, this will feel more like a "cockpit" for your mental health.

## 2. Technical Stack (The "Vibe-Ready" Flutter Stack)

-   **Framework**: Flutter (Dart).
-   **State Management**: Riverpod (for robust, testable state).
-   **Database**: Drift (SQLite abstraction, highly type-safe).
-   **Graphs**: fl_chart (declarative, beautiful charts).
-   **Notifications**: flutter_local_notifications (Local only, privacy-first).
-   **Location/Weather**: geolocator + open_meteo (Privacy-focused weather correlation).
-   **Routing**: GoRouter (Standard, declarative routing).

## 3. Database Schema (Drift/Dart Representation)

Provide this block to your IDE/Agent to understand the data model.

```dart
// Core Mood Entry
class MoodEntries extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  IntColumn get moodLevel => integer().check(moodLevel.isBetweenConstant(1, 10))(); // 1-10
  IntColumn get anxietyLevel => integer().nullable()();
  IntColumn get irritabilityLevel => integer().nullable()();
  RealColumn get sleepHours => real().nullable()();
  TextColumn get notes => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Medication Definitions
class Medications extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text()();
  TextColumn get dosage => text().nullable()();
  // Store time as string "HH:MM" or equivalent
  TextColumn get scheduleTime => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Medication Logs (Adherence)
class MedLogs extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get medicationId => text().references(Medications, #id)();
  DateTimeColumn get takenAt => dateTime().nullable()();
  // Status: 'taken', 'missed', 'late'
  TextColumn get status => text().withDefault(const Constant('pending'))();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Environmental Context
class WeatherSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entryId => text().references(MoodEntries, #id)();
  RealColumn get tempC => real().nullable()();
  IntColumn get cloudCoverPct => integer().nullable()();
  TextColumn get moonPhase => text().nullable()();
}
```

## 4. Feature Implementation Logic

### The Graph Engine (fl_chart)
-   **Dual-Axis equivalent**: Overlay a LineChart (Mood 1-10) with a BarChart (Sleep 0-12h).
-   **Markers**: Use ScatterChart data points along the X-axis to denote "Missed Meds".

### Weather Syncing
-   **Trigger**: On `MoodEntry` save.
-   **Logic**: 
    1.  Get current position (if permission granted).
    2.  Call Open-Meteo API: `https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true`.
    3.  Save snapshot linked to the Mood Entry.

### Local Privacy Reminders
-   **No External Server**: Unlike the web version, we use `flutter_local_notifications` to schedule daily reminders on the device itself.
-   **Action**: "Time for your morning Lithium".

## 5. The "Master Prompt" for Agentic Coding

Copy and paste this into your IDE/Agent context:

> "Act as a Senior Flutter Engineer. We are building 'Aura Mood,' a privacy-first Bipolar tracker.
>
> **Design Vibe**: Cyberpunk-Minimalist. Dark purple/slate palette (`Color(0xFF1A1A2E)` background). Heavy use of `BackdropFilter` for glassmorphism.
>
> **Tech Stack**: Flutter, Riverpod, Drift (SQLite), GoRouter.
>
> **Core Tasks**:
> 1.  Scaffold the app with a BottomNavigationBar (Dashboard, Logs, Analytics, Settings).
> 2.  Initialize Drift database with the schema defined in `Helper.md`.
> 3.  Create a 'Mood Check-in' UI with a sliding scale (1-10) and animated feedback.
> 4.  Implement the Medication Adherence checklist.
>
> Let's start by setting up the project structure and dependencies."