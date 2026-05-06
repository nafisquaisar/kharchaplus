import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/model/ExpenseModel.dart';

class ExpenseListItem extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseListItem({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isExpense = expense.type == ExpenseType.expense;

    final amountColor = isExpense ? Colors.red : Colors.green;

    final formattedDate =
    DateFormat("d MMM yyyy").format(expense.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [

          /// 🔥 CATEGORY ICON
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: _getCategoryColor(expense.categoryName)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(expense.categoryName),
              color: _getCategoryColor(expense.categoryName),
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          /// 🔥 TITLE + SUB INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// CATEGORY NAME
                Text(
                  expense.categoryName,
                  style: TextStyle(
                    fontSize: width * 0.038,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                /// DATE + PAYMENT MODE
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: width * 0.030,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(width: 8),

                    _paymentChip(expense.paymentMode),
                  ],
                ),

                /// NOTE (optional)
                if (expense.note != null &&
                    expense.note!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    expense.note!,
                    style: TextStyle(
                      fontSize: width * 0.028,
                      color: Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          /// 🔥 AMOUNT
          Text(
            "${isExpense ? "-" : "+"}₹${expense.amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: width * 0.038,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 PAYMENT MODE CHIP
  Widget _paymentChip(PaymentMode mode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        mode.name.toUpperCase(),
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  /// 🔥 CATEGORY ICON (BASIC MAPPING)
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "food":
        return Icons.restaurant;
      case "rent":
        return Icons.home;
      case "salary":
        return Icons.account_balance_wallet;
      case "transport":
        return Icons.directions_car;
      case "shopping":
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }

  /// 🔥 CATEGORY COLOR
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "food":
        return Colors.orange;
      case "rent":
        return Colors.blue;
      case "salary":
        return Colors.green;
      case "transport":
        return Colors.purple;
      case "shopping":
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}