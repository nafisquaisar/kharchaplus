import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/KharchaThemeColors.dart';
import '../../../../../core/utils/AppFlushbar.dart';
import '../../../../../core/utils/IdGenerator.dart';
import '../../../data/model/ExpenseCardModel.dart';
import '../../viewmodel/ExpenseCardViewModel.dart';
import 'widgets/DateSection.dart';
import 'widgets/DetailsSection.dart';
import 'widgets/SaveButton.dart';
import 'widgets/SheetHeader.dart';

class CreateExpenseCardSheet extends StatefulWidget {
  final ExpenseCardModel? card;

  const CreateExpenseCardSheet({super.key, this.card});

  @override
  State<CreateExpenseCardSheet> createState() =>
      _CreateExpenseCardSheetState();
}

class _CreateExpenseCardSheetState
    extends State<CreateExpenseCardSheet> {

  DateTime? startDate;
  DateTime? endDate;

  late TextEditingController titleController;
  late TextEditingController notesController;

  bool isLoading = false;

  bool get isEdit => widget.card != null;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.card?.title ?? "");
    notesController =
        TextEditingController(text: widget.card?.notes ?? "");

    startDate = widget.card?.startDate;
    endDate = widget.card?.endDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),

            SheetHeader(isEdit: isEdit),

            const SizedBox(height: 16),

            DateSection(
              startDate: startDate,
              endDate: endDate,
              onStartTap: () => pickDate(true),
              onEndTap: () => pickDate(false),
            ),

            const SizedBox(height: 16),

            DetailsSection(
              titleController: titleController,
              notesController: notesController,
            ),

            const SizedBox(height: 20),

            SaveCardButton(
              isEdit: isEdit,
              isLoading: isLoading,
              onPressed: submit,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ DATE PICKER
  Future<void> pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (startDate ?? DateTime.now())
          : (endDate ?? startDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (endDate != null && endDate!.isBefore(picked)) {
            endDate = picked;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  // ✅ STATUS CALCULATION (DON'T REMOVE)
  String calculateStatus(DateTime start, DateTime end) {
    final now = DateTime.now();

    if (now.isBefore(start)) return "Upcoming";
    if (now.isAfter(end)) return "Completed";
    return "Active";
  }

  // ✅ PROGRESS CALCULATION (DON'T REMOVE)
  double calculateProgress(DateTime start, DateTime end) {
    final now = DateTime.now();

    if (now.isBefore(start)) return 0.0;
    if (now.isAfter(end)) return 1.0;

    final totalDays = end.difference(start).inDays;
    final passedDays = now.difference(start).inDays;

    if (totalDays == 0) return 1.0;

    return (passedDays / totalDays).clamp(0.0, 1.0);
  }

  // ✅ SUBMIT (CREATE + UPDATE)
  void submit() async {
    if (isLoading) return;

    final title = titleController.text.trim();
    final notes = notesController.text.trim();

    if (title.isEmpty) {
      showError("Title is required");
      return;
    }

    if (startDate == null) {
      showError("Start date required");
      return;
    }

    final finalEndDate =
        endDate ?? startDate!.add(const Duration(days: 30));

    if (finalEndDate.isBefore(startDate!)) {
      showError("End date cannot be before start date");
      return;
    }

    setState(() => isLoading = true);

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final now = DateTime.now();

      final card = ExpenseCardModel(
        id: widget.card?.id ?? IdGenerator.generate(),
        userId: userId,
        title: title,
        notes: notes,
        startDate: startDate!,
        endDate: finalEndDate,
        totalExpense: widget.card?.totalExpense ?? 0,
        totalBudget: widget.card?.totalBudget ?? 0,
        totalIncome: widget.card?.totalIncome ?? 0,
        remainingAmount: widget.card?.remainingAmount ?? 0,
        totalItems: widget.card?.totalItems ?? 0,
        status: calculateStatus(startDate!, finalEndDate),
        progress: calculateProgress(startDate!, finalEndDate),
        createdAt: widget.card?.createdAt ?? now,
        updatedAt: now,
        isDeleted: false,
      );

      final vm = context.read<ExpenseCardViewModel>();

      if (isEdit) {
        await vm.updateCard(card);
      } else {
        await vm.addCard(card);
      }

      if (!mounted) return;

      Navigator.pop(context, isEdit ? "updated" : "created");

    } catch (e) {
      if (mounted) showError("Something went wrong");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ✅ ERROR HANDLING
  void showError(String message) {
    AppFlushbar.showError(context, message);
  }

}