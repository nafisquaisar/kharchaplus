import 'package:expense_tracker/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateExpenseCardSheet extends StatefulWidget {
  const CreateExpenseCardSheet({super.key});

  @override
  State<CreateExpenseCardSheet> createState() =>
      _CreateExpenseCardSheetState();
}

class _CreateExpenseCardSheetState extends State<CreateExpenseCardSheet> {
  DateTime? startDate;
  DateTime? endDate;

  final titleController = TextEditingController();
  final notesController = TextEditingController();

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat("d MMM yyyy").format(date);
  }

  Future<void> pickDate(bool isStart) async {
    DateTime initial = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.textSecondary,
      ),
      filled: true,
      fillColor: AppColors.background, // 🔥 clean input bg
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: width * 0.05,
        right: width * 0.05,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔥 Title
            Row(
              children: const [
                Icon(Icons.credit_card, size: 22),
                SizedBox(width: 8),
                Text(
                  "Create Expense Card",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 📅 DATE CARD
            _sectionCard(
              child: Column(
                children: [
                  _dateTile(
                    "Start Date",
                    startDate,
                        () => pickDate(true),
                  ),
                  const SizedBox(height: 12),
                  _dateTile(
                    "End Date (Optional)",
                    endDate,
                        () => pickDate(false),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 📝 DETAILS CARD
            _sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Title"),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    decoration: inputDecoration("January Cycle"),
                  ),

                  const SizedBox(height: 12),

                  const Text("Notes"),
                  const SizedBox(height: 6),
                  TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: inputDecoration("Add notes..."),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 🔥 BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () {
                  if (startDate == null) {
                    showError("Start date is required");
                    return;
                  }

                  if (endDate != null && endDate!.isBefore(startDate!)) {
                    showError("End date must be after start date");
                    return;
                  }

                  String title = titleController.text.trim();

                  if (title.isEmpty) {
                    title =
                    "${DateFormat("d MMM").format(startDate!)} - ${endDate != null ? DateFormat("d MMM").format(endDate!) : ""}";
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Card Created: $title"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text(
                  "Create Card",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card, // ✅ pure white
        borderRadius: BorderRadius.circular(16),

        // 🔥 subtle border (industry style)
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),

        // 🔥 soft shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _dateTile(String title, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.background, // 🔥 soft grey bg
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today,
                size: 18,
                color: AppColors.textSecondary),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                date == null ? title : formatDate(date),
                style: TextStyle(
                  color: date == null
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}