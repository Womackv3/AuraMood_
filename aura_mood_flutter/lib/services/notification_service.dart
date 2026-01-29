import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize Timezone
    tz.initializeTimeZones();
    try {
      final dynamic localTimezone = await FlutterTimezone.getLocalTimezone();
      String id;
      // Handle both String (older versions) and TimezoneInfo (newer versions)
      // Handle both String (older versions) and TimezoneInfo (newer versions)
      if (localTimezone is String) {
        id = localTimezone;
      } else {
        // Fallback: parse the string representation "TimezoneInfo(America/New_York, ...)"
        final str = localTimezone.toString();
        // Extract the ID between 'TimezoneInfo(' and the first comma
        final match = RegExp(r'TimezoneInfo\(([^,]+),').firstMatch(str);
        if (match != null) {
          id = match.group(1)!.trim();
        } else {
          // If regex fails, fallback to UTC
          debugPrint('Failed to parse TimezoneInfo: $str');
          id = 'UTC';
        }
      }
      tz.setLocalLocation(tz.getLocation(id));
    } catch (e) {
      debugPrint('Error setting timezone: $e');
      // Fallback to UTC or a safe default if detection fails
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
      macOS: darwinSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  /// Request notification permissions (Android 13+ & iOS)
  static Future<void> requestPermissions() async {
    // Android 13+ specific
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    
    // iOS/macOS permissions are requested during initialization via requestAlertPermission: true,
    // but we can also re-request or ensure it happens here if needed.
  }

  // Helper to schedule a daily notification at a specific time
  static Future<void> _scheduleDaily(int id, String title, String body, TimeOfDay time) async {
    await initialize();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'mood_channel',
            'Mood Check-in',
            channelDescription: 'Daily reminders to log your mood',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          macOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Repeats daily at this time
      );
    } catch (e) {
      debugPrint('Exact alarm scheduling failed: $e. Falling back to inexact.');
      // Fallback to inexact if permission denied
       await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'mood_channel',
            'Mood Check-in',
            channelDescription: 'Daily reminders to log your mood',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          macOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// Schedule AM Mood Check-in
  static Future<void> scheduleAmMoodReminder(TimeOfDay time) async {
    await _scheduleDaily(
      9001,
      'Morning Check-in',
      'How are you feeling this morning? Log your mood.',
      time,
    );
  }

  /// Schedule PM Mood Check-in
  static Future<void> schedulePmMoodReminder(TimeOfDay time) async {
    await _scheduleDaily(
      9002,
      'Evening Check-in',
      'Reflect on your day. Log your mood before bed.',
      time,
    );
  }

  /// Cancel AM Mood Reminder
  static Future<void> cancelAmMoodReminder() async {
    await initialize();
    await _plugin.cancel(9001);
  }

  /// Cancel PM Mood Reminder
  static Future<void> cancelPmMoodReminder() async {
    await initialize();
    await _plugin.cancel(9002);
  }

  // --- Restored Methods ---

  /// Schedule a daily notification for a medication
  static Future<void> scheduleMedicationReminder({
    required String medicationId,
    required String medicationName,
    required String? dosage,
    required TimeOfDay time,
  }) async {
    await initialize();

    // Use a hash of the medication ID for a stable notification ID
    final notifId = medicationId.hashCode.abs() % 100000;

    final body = dosage != null
        ? 'Time for your $medicationName ($dosage)'
        : 'Time for your $medicationName';

    // Schedule daily repeating notification
    // Note: providing a specific time for medication requires zonedSchedule too
    // But for now, we'll use the logic we had, or upgrade to zonedSchedule for consistency.
    // The previous implementation used periodicallyShow with RepeatInterval.daily, which allows no time control (it starts NOW).
    // To support "Time", we MUST use zonedSchedule essentially.
    
    // Let's us the new _scheduleDaily logic for medications too!
    await _scheduleDaily(
      notifId,
      'Medication Reminder',
      body,
      time,
    );
    
    debugPrint('Scheduled reminder for $medicationName at ${time.hour}:${time.minute}');
  }

  /// Cancel a specific medication reminder
  static Future<void> cancelMedicationReminder(String medicationId) async {
    await initialize();
    final notifId = medicationId.hashCode.abs() % 100000;
    await _plugin.cancel(notifId);
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    await initialize();
    await _plugin.cancelAll();
  }

  /// Send an immediate test notification
  static Future<void> sendTestNotification() async {
    await initialize();

    await _plugin.show(
      0,
      'Aura Mood',
      'Notifications are working!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
    );
  }
}
