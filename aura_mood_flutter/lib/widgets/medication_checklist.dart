import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

class MedicationChecklist extends ConsumerStatefulWidget {
  const MedicationChecklist({super.key});

  @override
  ConsumerState<MedicationChecklist> createState() => _MedicationChecklistState();
}

class _MedicationChecklistState extends ConsumerState<MedicationChecklist> {
  @override
  Widget build(BuildContext context) {
    final medications = ref.watch(medicationsProvider);
    final todayLogs = ref.watch(todayMedLogsProvider);

    // Build a set of medication IDs that have been taken today
    final takenMedIds = <String>{};
    todayLogs.whenData((logs) {
      for (final log in logs) {
        if (log.status == 'taken') {
          takenMedIds.add(log.medicationId);
        }
      }
    });

    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Medications',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                onPressed: () => _showMedicationDialog(context),
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: 16),
          medications.when(
            data: (meds) {
              if (meds.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.medication_outlined,
                          size: 48,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No medications added',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                onPressed: () => _showMedicationDialog(context),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Medication'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: meds.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final med = meds[index];
                  final isTaken = takenMedIds.contains(med.id);

                  return _MedicationTile(
                    medication: med,
                    isTaken: isTaken,
                    onTap: () => _toggleMedication(med, isTaken),
                    onEdit: () => _showMedicationDialog(context, med: med),
                    onDelete: () => _deleteMedication(med),
                  );
                },
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }

  void _toggleMedication(Medication med, bool currentlyTaken) async {
    final database = ref.read(databaseProvider);

    if (currentlyTaken) {
      // Find today's 'taken' log and update to 'missed'
      final existingLog = await database.getLatestMedLogToday(med.id);
      if (existingLog != null) {
        await database.updateMedLogStatus(existingLog.id, 'missed', null);
      }
    } else {
      // Insert a new 'taken' log
      await database.insertMedLog(
        MedLogsCompanion.insert(
          medicationId: med.id,
          scheduledFor: DateTime.now(),
          takenAt: Value(DateTime.now()),
          status: const Value('taken'),
        ),
      );
    }
  }

  void _deleteMedication(Medication med) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Medication?'),
        content: Text('Are you sure you want to delete "${med.name}"?'),
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
      await database.deleteMedication(med.id);
      await NotificationService.cancelMedicationReminder(med.id);
    }
  }

  // Unified Dialog for Add and Edit
  void _showMedicationDialog(BuildContext context, {Medication? med}) {
    final isEditing = med != null;
    final nameController = TextEditingController(text: med?.name ?? '');
    final dosageController = TextEditingController(text: med?.dosage ?? '');
    TimeOfDay? selectedTime;

    if (med?.scheduleTime != null) {
      try {
        final parts = med!.scheduleTime!.split(':');
        selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      } catch (_) {}
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(isEditing ? 'Edit Medication' : 'Add Medication'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Medication Name',
                    hintText: 'e.g., Lithium',
                  ),
                  autofocus: !isEditing,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dosageController,
                  decoration: const InputDecoration(
                    labelText: 'Dosage (optional)',
                    hintText: 'e.g., 300mg',
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Schedule Time'),
                  subtitle: Text(
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : 'Not set',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedTime != null)
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => setDialogState(() => selectedTime = null),
                        ),
                      const Icon(Icons.access_time),
                    ],
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime ?? TimeOfDay.now(),
                    );
                    if (time != null) {
                      setDialogState(() => selectedTime = time);
                    }
                  },
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
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a medication name'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                // Force close logic - ensure we pop first to avoid any blocking
                // However, we need context for DB. 
                // Let's capture values and pop at the end.
                
                final database = ref.read(databaseProvider);
                String? scheduleTime;
                if (selectedTime != null) {
                  scheduleTime = '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';
                }

                final medName = nameController.text.trim();
                final medDosage = dosageController.text.trim().isEmpty ? null : dosageController.text.trim();

                if (isEditing) {
                  // Update existing
                  await database.updateMedication(
                    MedicationsCompanion(
                      id: Value(med!.id),
                      name: Value(medName),
                      dosage: Value(medDosage),
                      scheduleTime: Value(scheduleTime),
                    ),
                  );
                  // Reschedule notification
                  try {
                    await NotificationService.cancelMedicationReminder(med.id);
                  } catch (e) {
                    debugPrint('Error canceling reminder: $e');
                  }
                } else {
                  // Insert new
                  await database.insertMedication(
                    MedicationsCompanion.insert(
                      name: medName,
                      dosage: Value(medDosage),
                      scheduleTime: Value(scheduleTime),
                    ),
                  );
                }

                if (selectedTime != null) {
                   try {
                     await NotificationService.scheduleMedicationReminder(
                      medicationId: isEditing ? med.id : medName.hashCode.toString(),
                      medicationName: medName,
                      dosage: medDosage,
                      time: selectedTime!,
                    );
                   } catch (e) {
                     debugPrint('Error scheduling reminder: $e');
                     if (context.mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text('Saved, but failed to schedule notification: $e')),
                       );
                     }
                   }
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicationTile extends StatelessWidget {
  final Medication medication;
  final bool isTaken;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MedicationTile({
    required this.medication,
    required this.isTaken,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onEdit, // Quick edit
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isTaken
              ? AppColors.success.withOpacity(0.15)
              : AppColors.glassBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isTaken ? AppColors.success : AppColors.glassBorder,
            width: isTaken ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isTaken ? AppColors.success : Colors.transparent,
                border: Border.all(
                  color: isTaken ? AppColors.success : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: isTaken
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isTaken ? AppColors.success : AppColors.textPrimary,
                      decoration: isTaken ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (medication.dosage != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      medication.dosage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Actions Menu
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 20, color: AppColors.textMuted),
              color: AppColors.surface,
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Edit')]),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [Icon(Icons.delete, size: 18, color: AppColors.error), SizedBox(width: 8), Text('Delete', style: TextStyle(color: AppColors.error))]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final dt = DateTime(2000, 1, 1, hour, minute);
      return DateFormat('h:mm a').format(dt);
    } catch (e) {
      return time;
    }
  }
}
