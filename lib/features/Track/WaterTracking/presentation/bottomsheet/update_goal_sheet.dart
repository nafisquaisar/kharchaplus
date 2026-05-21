import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/AppColors.dart';
import '../providers/goal/goal_provider.dart';

class UpdateGoalSheet extends ConsumerStatefulWidget {
  const UpdateGoalSheet({
    super.key,
  });

  @override
  ConsumerState<UpdateGoalSheet> createState() => _UpdateGoalSheetState();
}

class _UpdateGoalSheetState extends ConsumerState<UpdateGoalSheet> {
  final controller = TextEditingController();

  bool reminderEnabled = true;

  bool isSaving = false;

  int? _parseGoalMl(String raw) {
    final text = raw.trim().toLowerCase();
    if (text.isEmpty) return null;

    final isLiters = text.endsWith('l');
    final normalized = text.replaceAll('l', '').replaceAll(',', '.');
    final value = double.tryParse(normalized);
    if (value == null) return null;

    if (isLiters || value <= 20) {
      return (value * 1000).round();
    }

    return value.round();
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(goalNotifierProvider.notifier).loadGoal();
      final goal = ref.read(goalNotifierProvider).goal;

      if (goal != null) {
        controller.text = goal.dailyGoalMl.toString();
        reminderEnabled = goal.reminderEnabled;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
            'Update Daily Goal',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              hintText: 'Daily Goal in ml',
              filled: true,
              fillColor: AppColors.primarybg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  18,
                ),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SwitchListTile(
            value: reminderEnabled,
            activeThumbColor: AppColors.accent,
            title: const Text(
              'Enable Reminder',
            ),
            onChanged: (value) {
              setState(() {
                reminderEnabled = value;
              });
            },
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
                onPressed: isSaving
                    ? null
                    : () async {
                  final goal = _parseGoalMl(
                    controller.text,
                  );

                  if (goal == null || goal <= 0) {
                    _showSnackBar(
                      context,
                      'Enter a valid daily goal',
                    );
                    return;
                  }

                  setState(() {
                    isSaving = true;
                  });

                  try {
                    await ref
                        .read(
                          goalNotifierProvider.notifier,
                        )
                        .updateGoal(
                          dailyGoalMl: goal,
                          reminderEnabled: reminderEnabled,
                        );

                    if (context.mounted) {
                      _showSnackBar(
                        context,
                        'Daily goal updated',
                      );
                      Navigator.pop(
                        context,
                      );
                    }
                  } catch (_) {
                    _showSnackBar(
                      context,
                      'Failed to update goal',
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
                  'Update Goal',
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
