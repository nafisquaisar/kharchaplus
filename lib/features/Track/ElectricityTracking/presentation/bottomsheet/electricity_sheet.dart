import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../domain/entities/electricity_entity.dart';
import '../widgets/electricity_summary_card.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../domain/entities/electricity_entity.dart';
import '../widgets/electricity_summary_card.dart';

class ElectricitySheet extends StatefulWidget {

  final ElectricityEntity? entity;

  final String userId;

  final Future<bool> Function(
      ElectricityEntity,
      ) onSave;

  final void Function(
      String message,
      )? onValidationError;

  const ElectricitySheet({
    super.key,
    this.entity,
    required this.userId,
    required this.onSave,
    this.onValidationError,
  });

  @override
  State<ElectricitySheet> createState() =>
      _ElectricitySheetState();
}

class _ElectricitySheetState
    extends State<ElectricitySheet> {

  final titleController =
  TextEditingController();

  final prevController =
  TextEditingController();

  final currentController =
  TextEditingController();

  final rateController =
  TextEditingController();

  DateTime start = DateTime.now();

  DateTime end = DateTime.now();

  int consumed = 0;

  double total = 0;

  bool isSaving = false;

  @override
  void initState() {

    super.initState();

    if (widget.entity != null) {

      final entity = widget.entity!;

      titleController.text =
          entity.title ?? "";

      prevController.text =
          entity.prevUnit.toString();

      currentController.text =
          entity.currentUnit.toString();

      rateController.text =
          entity.rate.toString();

      start = entity.startDate;

      end = entity.endDate;
    }

    calculate();
  }

  @override
  void dispose() {

    titleController.dispose();

    prevController.dispose();

    currentController.dispose();

    rateController.dispose();

    super.dispose();
  }

  void calculate() {

    final prev =
        int.tryParse(prevController.text) ?? 0;

    final current =
        int.tryParse(currentController.text) ?? 0;

    final rate =
        double.tryParse(rateController.text) ?? 0;

    setState(() {

      consumed = current - prev;

      if (consumed < 0) {
        consumed = 0;
      }

      total = consumed * rate;
    });
  }

  Future<void> pickDate(
      bool isStart,
      ) async {

    final picked = await showDatePicker(

      context: context,

      initialDate:
      isStart ? start : end,

      firstDate: DateTime(2020),

      lastDate: DateTime(2100),
    );

    if (picked != null) {

      setState(() {

        if (isStart) {
          start = picked;
        } else {
          end = picked;
        }
      });
    }
  }

  ElectricityEntity _buildEntity() {

    final now = DateTime.now();

    final prev =
        int.tryParse(prevController.text) ?? 0;

    final current =
        int.tryParse(currentController.text) ?? 0;

    final rate =
        double.tryParse(rateController.text) ?? 0;

    final title =
    titleController.text.trim();

    final base = widget.entity;

    return ElectricityEntity(

      id: base?.id ??
          now.microsecondsSinceEpoch.toString(),

      title:
      title.isEmpty ? null : title,

      startDate: start,

      endDate: end,

      prevUnit: prev,

      currentUnit: current,

      rate: rate,

      isSynced:
      base?.isSynced ?? false,

      isDeleted:
      base?.isDeleted ?? false,

      isEdited:
      base?.isEdited ?? false,

      isActive:
      base?.isActive ?? true,

      isOfflineCreated:
      base?.isOfflineCreated ?? true,

      version:
      base?.version ?? 0,

      createdAt:
      base?.createdAt ?? now,

      updatedAt: now,

      userId:
      base?.userId ?? widget.userId,

      serverId:
      base?.serverId,
    );
  }

  String? _validate() {

    if (widget.userId.trim().isEmpty) {
      return 'User not authenticated';
    }

    if (start.isAfter(end)) {
      return 'Start date must be before end date';
    }

    final prev =
        int.tryParse(prevController.text) ?? -1;

    final current =
        int.tryParse(currentController.text) ?? -1;

    if (prev < 0 || current < 0) {
      return 'Enter valid unit readings';
    }

    if (prev > current) {
      return 'Previous unit must be <= current unit';
    }

    final rate =
        double.tryParse(rateController.text) ?? -1;

    if (rate <= 0) {
      return 'Enter a valid rate';
    }

    return null;
  }

  Future<void> submit() async {

    if (isSaving) {
      return;
    }

    final validationMessage =
    _validate();

    if (validationMessage != null) {

      widget.onValidationError?.call(
        validationMessage,
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {

      final entity =
      _buildEntity();

      await widget.onSave(entity);

    } catch (_) {

    } finally {

      if (mounted) {

        setState(() {
          isSaving = false;
        });
      }
    }
  }

  String formatDate(
      DateTime date,
      ) {

    return DateFormat(
      "d MMM yyyy",
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {

    final maxHeight =
        MediaQuery.of(context).size.height * 0.85;

    return Padding(

      padding: EdgeInsets.only(

        left: 16,
        right: 16,
        top: 16,

        bottom:
        MediaQuery.of(context).viewInsets.bottom,
      ),

      child: SizedBox(

        height: maxHeight,

        child: Column(

          children: [

            Container(

              width: 48,
              height: 5,

              decoration: BoxDecoration(

                color: AppColors.textSecondary
                    .withOpacity(0.3),

                borderRadius:
                BorderRadius.circular(12),
              ),
            ),

            const SizedBox(height: 12),

            Text(

              widget.entity == null
                  ? 'Add Electricity'
                  : 'Update Electricity',

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(

              child: SingleChildScrollView(

                child: Column(

                  children: [

                    _SectionCard(

                      title: 'Details',

                      child: Column(

                        children: [

                          _InputField(
                            controller: titleController,
                            hint: 'Title (Optional)',
                          ),

                          const SizedBox(height: 12),

                          _DateRow(
                            label: 'Start',
                            value: formatDate(start),
                            onTap: () => pickDate(true),
                          ),

                          const SizedBox(height: 10),

                          _DateRow(
                            label: 'End',
                            value: formatDate(end),
                            onTap: () => pickDate(false),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    _SectionCard(

                      title: 'Readings',

                      child: Column(

                        children: [

                          _InputField(
                            controller: prevController,
                            hint: 'Previous Unit',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => calculate(),
                          ),

                          const SizedBox(height: 10),

                          _InputField(
                            controller: currentController,
                            hint: 'Current Unit',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => calculate(),
                          ),

                          const SizedBox(height: 10),

                          _ReadOnlyRow(
                            label: 'Consumed Units',
                            value: '$consumed',
                          ),

                          const SizedBox(height: 10),

                          _InputField(
                            controller: rateController,
                            hint: 'Rate per Unit (₹)',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => calculate(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElectricitySummaryCard(
                      title: 'Calculation Summary',
                      amount: total,
                      subtitle: '$consumed units × rate',
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            SafeArea(

              top: false,

              child: SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed:
                  isSaving ? null : submit,

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                    AppColors.primary,

                    foregroundColor:
                    AppColors.textPrimary,

                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),

                  child: isSaving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    widget.entity == null
                        ? 'Save'
                        : 'Update',
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
}
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label: $value',
              style: TextStyle(color: AppColors.primary),
            ),
            Icon(
              Icons.calendar_today_rounded,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

