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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
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
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),

          if (reminderState.isLoading)
             Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
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
                  color: colorScheme.onSurfaceVariant,
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
                    color: colorScheme.onSurfaceVariant,
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
                  color: colorScheme.outlineVariant,
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
                    context: context,
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
                    color: colorScheme.onSurface,
                  ),

                  SizedBox(width: 6),

                  Text(
                    'Add Reminder',
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
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
    required BuildContext context,
    required IconData icon,
    required String time,
    required String repeat,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurface,
        ),

         SizedBox(width: 10),

        Expanded(
          child: Text(
            time,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),

        Text(
          repeat,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
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
              inactiveTrackColor: colorScheme.outlineVariant,
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