import 'package:expense_tracker/features/Expense/presentation/bottomsheet/AddExpenseSheet/widgets/AmountCard.dart';
import 'package:expense_tracker/features/Expense/presentation/bottomsheet/AddExpenseSheet/widgets/CategoryCard.dart';
import 'package:expense_tracker/features/Expense/presentation/bottomsheet/AddExpenseSheet/widgets/DetailsCard.dart';
import 'package:expense_tracker/features/Expense/presentation/bottomsheet/AddExpenseSheet/widgets/SaveButton.dart';
import 'package:expense_tracker/features/Expense/presentation/bottomsheet/AddExpenseSheet/widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../../../../core/utils/AppFlushbar.dart';
import '../../../../../core/utils/IdGenerator.dart';
import '../../../data/model/ExpenseModel.dart';
import '../../../data/model/category_model.dart';
import '../../viewmodel/CategoryViewModel.dart';

class AddExpenseSheet extends StatefulWidget {
  final String cardId;

  final ExpenseModel? expense;

  final String buttonText;

  final Future<void> Function(ExpenseModel expense) onAdd;

  const AddExpenseSheet({
    super.key,
    required this.cardId,
    required this.onAdd,

    this.expense,

    this.buttonText = "Save Expense",
  });

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  bool isSaving = false;

  DateTime selectedDate = DateTime.now();
  CategoryModel? selectedCategory;

  ExpenseType selectedType = ExpenseType.expense;

  PaymentMode selectedPayment = PaymentMode.cash;

  bool isValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      final expense = widget.expense!;

      amountController.text = expense.amount.toString();

      noteController.text = expense.note ?? "";

      selectedDate = expense.date;

      selectedType = expense.type;

      selectedPayment = expense.paymentMode;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final categoryVM = context.read<CategoryViewModel>();

        try {
          selectedCategory = categoryVM.categories.firstWhere(
            (e) => e.id == expense.categoryId,
          );

          validate();

          setState(() {});
        } catch (_) {}
      });
    }
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
        top: 14,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primarybg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 Header
            Header(
              title: widget.expense == null ? "Add Expense" : "Update Expense",
            ),
            const SizedBox(height: 10),

            /// 💰 Amount Card
            AmountCard(
              amountController: amountController,
              expenseType: selectedType,
              paymentMode: selectedPayment,

              onTypeChanged: (val) {
                setState(() {
                  selectedType = val;
                });
              },

              onPaymentChanged: (val) {
                setState(() {
                  selectedPayment = val;
                });
              },
            ),

            const SizedBox(height: 10),

            /// 📂 Category Card
            CategoryCard(
              categories: categoryVM.categories,
              selected: selectedCategory,

              onChanged: (val) {
                setState(() => selectedCategory = val);
                validate();
              },
            ),
            const SizedBox(height: 10),

            /// 📝 Details Card
            DetailsCard(
              selectedDate: selectedDate,

              onDateSelected: (date) {
                setState(() => selectedDate = date);
              },

              noteController: noteController,
            ),

            const SizedBox(height: 20),

            /// 🚀 Save Button
            SaveButton(
              text: widget.buttonText,
              isLoading: isSaving,
              onPressed: isSaving
                  ? () {}
                  : submit,
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> submit() async {
    /// 🔥 Prevent double click
    if (isSaving) return;

    /// 🔥 Validation
    if (amountController.text.trim().isEmpty) {
      AppFlushbar.showError(context, "Enter amount");

      return;
    }

    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      AppFlushbar.showError(context, "Enter valid amount");

      return;
    }

    if (selectedCategory == null) {
      AppFlushbar.showError(context, "Select category");

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        AppFlushbar.showError(context, "User not logged in");

        return;
      }

      final now = DateTime.now();

      final isUpdate = widget.expense != null;

      final expense = ExpenseModel(
        id: widget.expense?.id ?? IdGenerator.generate(),

        userId: user.uid,

        cardId: widget.cardId,

        amount: amount,

        categoryId: selectedCategory!.id,

        categoryName: selectedCategory!.name,

        note: noteController.text.trim(),

        type: selectedType,

        paymentMode: selectedPayment,

        date: selectedDate,

        createdAt: widget.expense?.createdAt ?? now,

        updatedAt: now,

        currency: 'INR',

        isDeleted: false,
      );

      await widget.onAdd(expense);

      if (!context.mounted) {
        return;
      }


      AppFlushbar.showSuccess(
        context,

        isUpdate
            ? "Expense updated successfully"
            : "Expense added successfully",
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      AppFlushbar.showError(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }
}
