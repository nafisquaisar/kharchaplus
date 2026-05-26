/// 📄 ExpenseTypeSelector.dart
library;

import 'package:flutter/material.dart';

import '../../../../../../../core/constants/AppColors.dart';
import '../../../../../data/model/ExpenseModel.dart';



class ExpenseTypeSelector extends StatelessWidget {
  final ExpenseType selected;
  final Function(ExpenseType) onChanged;

  const ExpenseTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = selected == ExpenseType.expense;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        onChanged(
          isExpense
              ? ExpenseType.income
              : ExpenseType.expense,
        );
      },

      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpense
                ? Colors.red.withOpacity(.2)
                : Colors.green.withOpacity(.2),
          ),
        ),

        child: Row(
          children: [

            Icon(
              isExpense
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: isExpense
                  ? Colors.red
                  : Colors.green,
              size: 18,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                isExpense
                    ? "Expense"
                    : "Income",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isExpense
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}