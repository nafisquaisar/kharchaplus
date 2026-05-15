import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../domain/entities/water_reminder_entity.dart';
import '../providers/reminder/reminder_provider.dart';

class UpdateReminderSheet extends ConsumerStatefulWidget {
  final WaterReminderEntity reminder;

  const UpdateReminderSheet({
    super.key,
    required this.reminder,
  });

  @override
  ConsumerState<UpdateReminderSheet> createState() =>
      _UpdateReminderSheetState();
}

class _UpdateReminderSheetState extends ConsumerState<UpdateReminderSheet> {
  late TimeOfDay selectedTime;
  late bool repeatDaily;
  late bool enabled;
  bool isSaving = false;
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
    selectedTime =
        TimeOfDay(hour: widget.reminder.hour, minute: widget.reminder.minute);
    repeatDaily = widget.reminder.repeatDaily;
    enabled = widget.reminder.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Reminder',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (time == null) return;
                setState(() {
                  selectedTime = time;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarybg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  selectedTime.format(context),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: repeatDaily,
              activeColor: AppColors.accent,
              title: const Text('Repeat Daily'),
              onChanged: (value) {
                setState(() {
                  repeatDaily = value;
                });
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: enabled,
              activeColor: AppColors.accent,
              title: const Text('Enable Reminder'),
              onChanged: (value) {
                setState(() {
                  enabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: isSaving
                    ? null
                    : () async {
                        HapticFeedback.lightImpact();

                        setState(() {
                          isSaving = true;
                        });

                        try {
                          await ref
                              .read(reminderNotifierProvider.notifier)
                              .updateReminder(
                                reminderId: widget.reminder.id,
                                hour: selectedTime.hour,
                                minute: selectedTime.minute,
                                repeatDaily: repeatDaily,
                                enabled: enabled,
                              );

                          if (context.mounted) {
                            _showSnackBar(context, 'Reminder updated');
                            Navigator.pop(context);
                          }
                        } catch (_) {
                          _showSnackBar(
                            context,
                            'Failed to update reminder',
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              isSaving = false;
                            });
                          }
                        }
                      },
                child: isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: isDeleting
                    ? null
                    : () async {
                        HapticFeedback.lightImpact();
                        setState(() {
                          isDeleting = true;
                        });

                        try {
                          await ref
                              .read(reminderNotifierProvider.notifier)
                              .deleteReminder(widget.reminder.id);

                          if (context.mounted) {
                            _showSnackBar(context, 'Reminder deleted');
                            Navigator.pop(context);
                          }
                        } catch (_) {
                          _showSnackBar(
                            context,
                            'Failed to delete reminder',
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              isDeleting = false;
                            });
                          }
                        }
                      },
                child: Text(
                  isDeleting ? 'Deleting...' : 'Delete Reminder',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

