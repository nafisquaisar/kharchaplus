import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/model/ExpenseModel.dart';

class ExpenseListItem extends StatelessWidget {

  final ExpenseModel expense;

  final Future<void> Function() onEdit;

  final Future<void> Function() onDelete;

  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isExpense =
        expense.type ==
            ExpenseType.expense;

    final amountColor =
    isExpense
        ? Colors.red
        : Colors.green;

    final formattedDate =
    DateFormat("d MMM yyyy")
        .format(expense.date);

    return Dismissible(

      key: ValueKey(expense.id),

      direction:
      DismissDirection.horizontal,

      /// 🔥 RIGHT SWIPE → UPDATE
      background: _swipeBackground(

        color: Colors.blue,

        icon: Icons.edit,

        alignment:
        Alignment.centerLeft,
      ),

      /// 🔥 LEFT SWIPE → DELETE
      secondaryBackground:
      _swipeBackground(

        color: Colors.red,

        icon: Icons.delete,

        alignment:
        Alignment.centerRight,
      ),

      confirmDismiss:
          (direction) async {

        /// 🔥 UPDATE

        if (direction ==
            DismissDirection
                .startToEnd) {

          await onEdit();

          return false;
        }

        /// 🔥 DELETE

        final confirm =
        await showDialog<bool>(

          context: context,

          builder: (_) {

            return AlertDialog(

              title: const Text(
                "Delete Expense",
              ),

              content: const Text(
                "Are you sure you want to delete this transaction?",
              ),

              actions: [

                TextButton(

                  onPressed: () {

                    Navigator.pop(
                      context,
                      false,
                    );
                  },

                  child: const Text(
                    "Cancel",
                  ),
                ),

                ElevatedButton(

                  onPressed: () {

                    Navigator.pop(
                      context,
                      true,
                    );
                  },

                  child: const Text(
                    "Delete",
                  ),
                ),
              ],
            );
          },
        );

        return confirm ?? false;
      },

      onDismissed: (_) async {

        await onDelete();
      },

      /// 🔥 ORIGINAL UI (UNCHANGED)
      child: Container(

        margin:
        const EdgeInsets.only(
          bottom: 10,
        ),

        padding:
        const EdgeInsets.all(12),

        decoration: BoxDecoration(

          color: colorScheme.surface,

          borderRadius:
          BorderRadius.circular(
            14,
          ),

          boxShadow: [

            BoxShadow(

              color: colorScheme.shadow.withOpacity(0.03),

              blurRadius: 6,

              offset:
              const Offset(
                0,
                2,
              ),
            ),
          ],
        ),

        child: Row(

          children: [

            /// 🔥 CATEGORY ICON
            Container(

              height: 40,
              width: 40,

              decoration:
              BoxDecoration(

                color:
                _getCategoryColor(
                  expense.categoryName,
                ).withOpacity(
                  0.1,
                ),

                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),

              child: Icon(

                _getCategoryIcon(
                  expense.categoryName,
                ),

                color:
                _getCategoryColor(
                  expense.categoryName,
                ),

                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            /// 🔥 CONTENT
            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                    Text(

                    expense.categoryName,

                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: width * 0.038,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Row(

                    children: [

                      Text(

                        formattedDate,

                        style: textTheme.bodySmall?.copyWith(
                          fontSize: width * 0.030,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      _paymentChip(
                        context,
                        expense.paymentMode,
                      ),
                    ],
                  ),

                  if (expense.note !=
                      null &&
                      expense.note!
                          .isNotEmpty) ...[

                    const SizedBox(
                      height: 2,
                    ),

                    Text(

                      expense.note!,

                      style: textTheme.bodySmall?.copyWith(
                        fontSize: width * 0.028,
                        color: colorScheme.onSurfaceVariant,
                      ),

                      maxLines: 1,

                      overflow:
                      TextOverflow
                          .ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            Text(

              "${isExpense ? "-" : "+"}₹${expense.amount.toStringAsFixed(0)}",

              style: textTheme.bodyMedium?.copyWith(
                fontSize: width * 0.038,
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 SWIPE BG

  Widget _swipeBackground({

    required Color color,

    required IconData icon,

    required Alignment alignment,
  }) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),

      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      alignment: alignment,

      decoration: BoxDecoration(

        color:
        color.withOpacity(0.15),

        borderRadius:
        BorderRadius.circular(
          14,
        ),
      ),

      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  /// 🔥 PAYMENT CHIP

  Widget _paymentChip(
      BuildContext context,
      PaymentMode mode) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),

      decoration: BoxDecoration(

        color: colorScheme.surfaceContainerHighest,

        borderRadius:
        BorderRadius.circular(
          6,
        ),
      ),

      child: Text(

        mode.name.toUpperCase(),

        style: textTheme.bodySmall?.copyWith(
          fontSize: 10,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(
      String category) {

    switch (
    category.toLowerCase()) {

      case "food":
        return Icons.restaurant;

      case "rent":
        return Icons.home;

      case "salary":
        return Icons
            .account_balance_wallet;

      case "transport":
        return Icons.directions_car;

      case "shopping":
        return Icons.shopping_bag;

      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(
      String category) {

    switch (
    category.toLowerCase()) {

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