import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../data/model/expense_model.dart';
import 'expense_item.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenses,
    required this.onDelete,
    required this.onEdit,
  });

  final List<Expense> expenses;
  final ValueChanged<String> onDelete;
  final Function(Expense) onEdit;

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.receipt_long, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'No expenses yet',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];

        return Dismissible(
          key: ValueKey(expense.id),

          // ✅ Improved delete UI
          background: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.deleteBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),

          confirmDismiss: (_) async {
            return await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: AppColors.card,
                title: const Text('Delete Expense'),
                content: const Text('Are you sure you want to delete this?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deleteBackground,
                    ),
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },

          onDismissed: (_) => onDelete(expense.id),

          child: ExpenseItem(
            expense: expense,
            onLongPress: () => onEdit(expense),
          ),
        );
      },
    );
  }
}