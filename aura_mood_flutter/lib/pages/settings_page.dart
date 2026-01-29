import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/database_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = false; // For Meds
  
  // Mood Reminder State
  bool _amReminderEnabled = false;
  TimeOfDay _amReminderTime = const TimeOfDay(hour: 9, minute: 0);
  
  bool _pmReminderEnabled = false;
  TimeOfDay _pmReminderTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('med_notifications') ?? false;
      _amReminderEnabled = prefs.getBool('am_reminder') ?? false;
      _pmReminderEnabled = prefs.getBool('pm_reminder') ?? false;
      
      final amHour = prefs.getInt('am_hour') ?? 9;
      final amMinute = prefs.getInt('am_minute') ?? 0;
      _amReminderTime = TimeOfDay(hour: amHour, minute: amMinute);

      final pmHour = prefs.getInt('pm_hour') ?? 20;
      final pmMinute = prefs.getInt('pm_minute') ?? 0;
      _pmReminderTime = TimeOfDay(hour: pmHour, minute: pmMinute);
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('med_notifications', _notificationsEnabled);
    await prefs.setBool('am_reminder', _amReminderEnabled);
    await prefs.setBool('pm_reminder', _pmReminderEnabled);
    
    await prefs.setInt('am_hour', _amReminderTime.hour);
    await prefs.setInt('am_minute', _amReminderTime.minute);
    
    await prefs.setInt('pm_hour', _pmReminderTime.hour);
    await prefs.setInt('pm_minute', _pmReminderTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: false,
            backgroundColor: Colors.transparent,
            title: Text(
              'SETTINGS',
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
                // Notifications Section
                GlassContainer(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Notifications',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Medication Reminders'),
                        subtitle: const Text('Daily reminders for scheduled meds'),
                        value: _notificationsEnabled,
                        onChanged: (value) async {
                          setState(() => _notificationsEnabled = value);
                          _saveSettings();
                          if (value) {
                            await _scheduleMedReminders();
                          } else {
                            await NotificationService.cancelAll();
                            // Re-schedule mood reminders if they shouldn't be cancelled by this global kill switch
                            // Ideally cancelAllMedicationReminders should exist, but for now we rebuild.
                            if (_amReminderEnabled) NotificationService.scheduleAmMoodReminder(_amReminderTime);
                            if (_pmReminderEnabled) NotificationService.schedulePmMoodReminder(_pmReminderTime);
                          }
                        },
                        activeColor: AppColors.accent,
                      ),
                      
                      const Divider(color: AppColors.glassBorder),
                      
                      // AM Reminder Section
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Morning Check-in'),
                        subtitle: Text(_formatTime(_amReminderTime)),
                        value: _amReminderEnabled,
                        onChanged: (value) async {
                          setState(() => _amReminderEnabled = value);
                          _saveSettings();
                          if (value) {
                            await NotificationService.scheduleAmMoodReminder(_amReminderTime);
                          } else {
                            await NotificationService.cancelAmMoodReminder();
                          }
                        },
                        activeColor: AppColors.accent,
                      ),
                      if (_amReminderEnabled)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: TextButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _amReminderTime,
                              );
                              if (time != null) {
                                setState(() => _amReminderTime = time);
                                _saveSettings();
                                await NotificationService.scheduleAmMoodReminder(time);
                              }
                            },
                            child: const Text('Change Time'),
                          ),
                        ),

                      const Divider(color: AppColors.glassBorder),

                      // PM Reminder Section
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Evening Check-in'),
                        subtitle: Text(_formatTime(_pmReminderTime)),
                        value: _pmReminderEnabled,
                        onChanged: (value) async {
                          setState(() => _pmReminderEnabled = value);
                          _saveSettings();
                          if (value) {
                            await NotificationService.schedulePmMoodReminder(_pmReminderTime);
                          } else {
                            await NotificationService.cancelPmMoodReminder();
                          }
                        },
                        activeColor: AppColors.accent,
                      ),
                       if (_pmReminderEnabled)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: TextButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _pmReminderTime,
                              );
                              if (time != null) {
                                setState(() => _pmReminderTime = time);
                                _saveSettings();
                                await NotificationService.schedulePmMoodReminder(time);
                              }
                            },
                            child: const Text('Change Time'),
                          ),
                        ),
                      const Divider(color: AppColors.glassBorder),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _sendTestNotification,
                          icon: const Icon(Icons.send),
                          label: const Text('Send Test Notification'),
                        ),
                      ),
                    ],
                  ),
                ),

                // Privacy Section
                GlassContainer(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Privacy',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _InfoRow(
                        icon: Icons.storage_outlined,
                        label: 'Data Storage',
                        value: 'Local only (SQLite)',
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.cloud_off_outlined,
                        label: 'Cloud Sync',
                        value: 'Disabled',
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        value: 'Used for weather only',
                      ),
                    ],
                  ),
                ),

                // Data Management
                GlassContainer(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.folder_outlined,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Data Management',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.download_outlined),
                        title: const Text('Export Data'),
                        subtitle: const Text('Download your mood history'),
                        onTap: _exportData,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                        ),
                        title: const Text(
                          'Clear All Data',
                          style: TextStyle(color: AppColors.error),
                        ),
                        subtitle: const Text('Permanently delete all entries'),
                        onTap: _confirmClearData,
                      ),
                    ],
                  ),
                ),

                // About Section
                GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'About',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _InfoRow(
                        icon: Icons.apps,
                        label: 'Version',
                        value: '1.0.0',
                      ),
                      const SizedBox(height: 12),
                      const _InfoRow(
                        icon: Icons.flutter_dash,
                        label: 'Built with',
                        value: 'Flutter',
                      ),
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

  Future<void> _sendTestNotification() async {
    try {
      await NotificationService.sendTestNotification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test notification sent!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _scheduleMedReminders() async {
    final database = ref.read(databaseProvider);
    final meds = await database.getAllMedications();
    for (final med in meds) {
      if (med.scheduleTime != null) {
        final parts = med.scheduleTime!.split(':');
        final time = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
        await NotificationService.scheduleMedicationReminder(
          medicationId: med.id,
          medicationName: med.name,
          dosage: med.dosage,
          time: time,
        );
      }
    }
  }

  void _exportData() async {
    try {
      final database = ref.read(databaseProvider);
      final entries = await database.getAllMoodEntries();
      final medications = await database.getAllMedications();

      final exportData = {
        'exportDate': DateTime.now().toIso8601String(),
        'moodEntries': entries.map((e) => {
          'id': e.id,
          'timestamp': e.timestamp.toIso8601String(),
          'moodLevel': e.moodLevel,
          'anxietyLevel': e.anxietyLevel,
          'irritabilityLevel': e.irritabilityLevel,
          'sleepHours': e.sleepHours,
          'notes': e.notes,
        }).toList(),
        'medications': medications.map((m) => {
          'id': m.id,
          'name': m.name,
          'dosage': m.dosage,
          'scheduleTime': m.scheduleTime,
        }).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyy-MM-dd_HHmmss').format(DateTime.now());
      final file = File('${dir.path}/aura_mood_export_$timestamp.json');
      await file.writeAsString(jsonString);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported to ${file.path}'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _confirmClearData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your mood entries, medications, and logs. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data cleared'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textMuted),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
