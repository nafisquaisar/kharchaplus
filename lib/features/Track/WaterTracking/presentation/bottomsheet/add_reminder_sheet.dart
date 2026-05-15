import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/AppColors.dart';
import '../providers/reminder/reminder_provider.dart';

class AddReminderSheet extends ConsumerStatefulWidget {
  const AddReminderSheet({
    super.key,
  });

  @override
  ConsumerState<AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends ConsumerState<AddReminderSheet> {
  TimeOfDay? selectedTime;
  bool repeatDaily = true;
  bool enabled = true;
  bool isSaving = false;

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
              'Add Reminder',
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
                  initialTime: TimeOfDay.now(),
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
                  selectedTime == null
                      ? 'Select time'
                      : selectedTime!.format(context),
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
                        if (selectedTime == null) {
                          _showSnackBar(context, 'Please select a time');
                          return;
                        }

                        setState(() {
                          isSaving = true;
                        });

                        try {
                          await ref
                              .read(reminderNotifierProvider.notifier)
                              .addReminder(
                                hour: selectedTime!.hour,
                                minute: selectedTime!.minute,
                                repeatDaily: repeatDaily,
                                enabled: enabled,
                              );

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (_) {
                          _showSnackBar(
                            context,
                            'Failed to save reminder',
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
                        'Save Reminder',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
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


