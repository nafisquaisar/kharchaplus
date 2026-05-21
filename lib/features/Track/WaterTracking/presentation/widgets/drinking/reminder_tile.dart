import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../bottomsheet/add_reminder_sheet.dart';
import '../../bottomsheet/update_reminder_sheet.dart';
import '../../providers/reminder/reminder_provider.dart';

class ReminderTile extends ConsumerWidget {
  const ReminderTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(reminderNotifierProvider);

    Future<void> updateReminder(String id, bool value) async {
      HapticFeedback.lightImpact();
      await ref
          .read(reminderNotifierProvider.notifier)
          .toggleReminder(id, value);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Reminders',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          if (reminderState.isLoading)
             Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else if (reminderState.error != null)
             Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Failed to load reminders',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(height: 10),

          // ======================
          // REMINDER 1
          // ======================

          if (reminderState.reminders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No reminders yet',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reminderState.reminders.length,
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey.shade200,
                  height: 14,
                );
              },
              itemBuilder: (context, index) {
                final reminder = reminderState.reminders[index];
                final time = _formatTime(
                  context,
                  reminder.hour,
                  reminder.minute,
                );
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => UpdateReminderSheet(
                        reminder: reminder,
                      ),
                    );
                  },
                  child: _buildReminderRow(
                    icon: Icons.notifications_none_rounded,
                    time: time,
                    repeat: reminder.repeatDaily ? 'Everyday' : 'Once',
                    value: reminder.enabled,
                    onChanged: reminderState.isLoading
                        ? null
                        : (value) {
                            updateReminder(reminder.id, value);
                          },
                  ),
                );
              },
            ),

          const SizedBox(height: 6),

          // ======================
          // ADD REMINDER
          // ======================

          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) {
                  return const AddReminderSheet();
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: Row(
                children:  [
                  Icon(
                    Icons.add,
                    size: 16,
                    color: AppColors.colorText,
                  ),

                  SizedBox(width: 6),

                  Text(
                    'Add Reminder',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.colorText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderRow({
    required IconData icon,
    required String time,
    required String repeat,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.colorText,
        ),

         SizedBox(width: 10),

        Expanded(
          child: Text(
            time,
            style:  TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),

        Text(
          repeat,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(width: 10),

        SizedBox(
          height: 24,
          child: Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.colorText,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade300,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(BuildContext context, int hour, int minute) {
    final time = TimeOfDay(hour: hour, minute: minute);
    return MaterialLocalizations.of(context).formatTimeOfDay(
      time,
      alwaysUse24HourFormat: false,
    );
  }
}