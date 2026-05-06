import 'package:flutter/material.dart';
import '../../../data/model/ExpenseModel.dart';
import '../ExpensePage/expense_list_item.dart';

class TransactionList extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const TransactionList({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: expenses
          .map((e) => ExpenseListItem(expense: e))
          .toList(),
    );
  }
}