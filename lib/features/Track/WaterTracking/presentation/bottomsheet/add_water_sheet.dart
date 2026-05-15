import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../../../../core/utils/AppFlushbar.dart';
import '../../domain/entities/water_intake_entity.dart';
import '../providers/intake/intake_provider.dart';

typedef IntakeSheetSubmit = Future<bool> Function({
  required int amountMl,
  required DateTime dateTime,
  required String sourceType,
});

class AddWaterSheet extends ConsumerStatefulWidget {
  final WaterIntakeEntity? existingIntake;
  final IntakeSheetSubmit? onSubmit;

  const AddWaterSheet({
    super.key,
    this.existingIntake,
    this.onSubmit,
  });

  @override
  ConsumerState<AddWaterSheet> createState() => _AddWaterSheetState();
}

class _AddWaterSheetState extends ConsumerState<AddWaterSheet> {
  static const _sourceOptions = <String>[
    'Manual',
    'Quick Add',
    'Bottle',
    'Glass',
    'Other',
  ];

  late final TextEditingController controller;
  late DateTime selectedDateTime;
  late String selectedSourceType;

  bool isSaving = false;

  bool get isEditMode => widget.existingIntake != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingIntake;
    controller = TextEditingController(
      text: existing?.amountMl.toString() ?? '',
    );
    selectedDateTime = existing?.dateTime ?? DateTime.now();
    selectedSourceType = existing?.sourceType ?? 'Manual';
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
            Center(
              child: Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isEditMode ? 'Update Water Intake' : 'Add Water Intake',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter amount in ml',
                filled: true,
                fillColor: AppColors.primarybg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            _DateTimeCard(
              dateTime: selectedDateTime,
              onPickDate: _pickDate,
              onPickTime: _pickTime,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: selectedSourceType,
              decoration: InputDecoration(
                hintText: 'Source Type',
                filled: true,
                fillColor: AppColors.primarybg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _sourceOptions
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  selectedSourceType = value;
                });
              },
            ),
            const SizedBox(height: 24),
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
                onPressed: isSaving ? null : _save,
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
                    : Text(
                        isEditMode ? 'Update Intake' : 'Add Intake',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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

  Future<void> _save() async {
    final amount = int.tryParse(
      controller.text.trim(),
    );

    if (amount == null || amount <= 0) {
      AppFlushbar.showError(
        context,
        'Enter a valid amount in ml',
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      bool success;
      if (widget.onSubmit != null) {
        success = await widget.onSubmit!(
          amountMl: amount,
          dateTime: selectedDateTime,
          sourceType: selectedSourceType,
        );
      } else {
        await ref.read(intakeNotifierProvider.notifier).addIntake(
              amount,
              dateTime: selectedDateTime,
              sourceType: selectedSourceType,
            );
        success = true;
      }

      if (!mounted) {
        return;
      }

      if (success) {
        Navigator.pop(context, 'saved');
      } else {
        AppFlushbar.showError(
          context,
          isEditMode ? 'Failed to update intake' : 'Failed to save intake',
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppFlushbar.showError(
        context,
        isEditMode ? 'Failed to update intake' : 'Failed to save intake',
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now().subtract(
        const Duration(days: 3650),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      selectedDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedDateTime.hour,
        selectedDateTime.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      selectedDateTime = DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        picked.hour,
        picked.minute,
      );
    });
  }
}

class _DateTimeCard extends StatelessWidget {
  final DateTime dateTime;
  final Future<void> Function() onPickDate;
  final Future<void> Function() onPickTime;

  const _DateTimeCard({
    required this.dateTime,
    required this.onPickDate,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('dd MMM yyyy').format(dateTime);
    final timeLabel = DateFormat('hh:mm a').format(dateTime);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarybg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _DateTimePill(
              icon: Icons.calendar_today_rounded,
              label: dateLabel,
              onTap: onPickDate,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _DateTimePill(
              icon: Icons.access_time_rounded,
              label: timeLabel,
              onTap: onPickTime,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTimePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Future<void> Function() onTap;

  const _DateTimePill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.accent,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
