import 'package:expense_tracker/features/Expense/presentation/bottomsheet/AddExpenseSheet/widgets/AddCategoryDialog.dart';
import 'package:expense_tracker/features/Expense/presentation/bottomsheet/AddExpenseSheet/widgets/CategoryDropdown.dart';
import 'package:expense_tracker/features/Expense/presentation/bottomsheet/AddExpenseSheet/widgets/DatePickerField.dart';
import 'package:expense_tracker/features/Expense/presentation/bottomsheet/AddExpenseSheet/widgets/NoteField.dart';
import 'package:expense_tracker/features/Expense/presentation/bottomsheet/AddExpenseSheet/widgets/SaveButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/KharchaThemeColors.dart';
import '../../../data/model/ExpenseModel.dart';
import '../../../data/model/category_model.dart';
import '../../viewmodel/CategoryViewModel.dart';

class AddExpenseSheet extends StatefulWidget {
  final String cardId;
  final Function(ExpenseModel expense) onAdd;

  const AddExpenseSheet({
    super.key,
    required this.cardId,
    required this.onAdd,
  });

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  CategoryModel? selectedCategory;

  bool isValid = false;

  @override
  void initState() {
    super.initState();
    amountController.addListener(validate);
  }

  void validate() {
    final valid = amountController.text.isNotEmpty && selectedCategory != null;
    if (valid != isValid) {
      setState(() => isValid = valid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryVM = context.watch<CategoryViewModel>();

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// 🔘 Drag Handle
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          /// 🧾 Title
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Add Expense",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),

          const SizedBox(height: 24),

          /// 💰 Amount (Hero Field)
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixText: "₹ ",
              hintText: "0.00",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 📂 Category
          CategoryDropdown(
            categories: categoryVM.categories,
            selected: selectedCategory,
            onChanged: (val) {
              setState(() => selectedCategory = val);
              validate();
            },
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => showAddCategoryDialog(context),
              child: const Text("Add Category"),
            ),
          ),

          const SizedBox(height: 12),

          /// 📅 Date + 📝 Note Row
          Row(
            children: [
              Expanded(
                child: DatePickerField(
                  selectedDate: selectedDate,
                  onDateSelected: (date) {
                    setState(() => selectedDate = date);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: "Note",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// 🚀 Save Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: isValid ? submit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Save Expense",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submit() {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        return;
      }

      final now = DateTime.now();

      final expense = ExpenseModel(
        id: now.millisecondsSinceEpoch.toString(),
        userId: user.uid,
        cardId: widget.cardId,
        amount: double.tryParse(amountController.text) ?? 0,
        categoryId: selectedCategory!.id,
        categoryName: selectedCategory!.name,
        note: noteController.text.trim(),
        type: ExpenseType.expense,
        paymentMode: PaymentMode.cash,
        date: selectedDate,
        createdAt: now,
        updatedAt: now,
        currency: 'INR',
      );

      widget.onAdd(expense);
      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}