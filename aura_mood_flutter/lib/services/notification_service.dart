import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      macOS: darwinSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

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
    await _plugin.periodicallyShow(
      notifId,
      'Medication Reminder',
      body,
      RepeatInterval.daily,
      const NotificationDetails(
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
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

  /// Schedule a daily mood check-in reminder
  static Future<void> scheduleMoodReminder() async {
    await initialize();

    await _plugin.periodicallyShow(
      99999,
      'Mood Check-in',
      'How are you feeling? Take a moment to log your mood.',
      RepeatInterval.daily,
      const NotificationDetails(
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
    );
  }

  /// Cancel the mood reminder
  static Future<void> cancelMoodReminder() async {
    await initialize();
    await _plugin.cancel(99999);
  }
}
