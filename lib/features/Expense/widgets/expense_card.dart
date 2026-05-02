import 'package:flutter/material.dart';
import '../../../core/constants/KharchaThemeColors.dart';
import '../../../core/constants/colors.dart';

class ExpenseCard extends StatefulWidget {
  final String title;
  final String amount;
  final String items;
  final String status;
  final bool isHighlighted;
  final double progress; // 0.0 - 1.0
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ExpenseCard({
    super.key,
    required this.title,
    required this.amount,
    required this.items,
    required this.status,
    this.isHighlighted = false,
    this.progress = 0.5,
    this.icon = Icons.currency_rupee,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  double scale = 1;

  void _onTapDown(_) => setState(() => scale = 0.97);
  void _onTapUp(_) => setState(() => scale = 1);
  void _onTapCancel() => setState(() => scale = 1);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Dismissible(
      key: UniqueKey(),
      background: _swipeBackground(
        color: Colors.green,
        icon: Icons.edit,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _swipeBackground(
        color: Colors.red,
        icon: Icons.delete,
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onEdit?.call();
          return false;
        } else {
          widget.onDelete?.call();
          return true;
        }
      },

      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,

        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),

          child: Container(
            margin: EdgeInsets.only(bottom: width * 0.03),
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: width * 0.03, // 🔥 reduced
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: widget.isHighlighted
                    ? AppColors.primary.withOpacity(0.3)
                    : Colors.black.withOpacity(0.04),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔥 TOP ROW
                Row(
                  children: [

                    /// ICON
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// TITLE
                    Expanded(
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: width * 0.038,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    /// ITEMS
                    if (widget.items.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.items,
                          style: TextStyle(
                            fontSize: width * 0.03,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: width * 0.025),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🔥 LEFT SIDE (Label + Amount)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Expense",
                            style: TextStyle(
                              fontSize: width * 0.028,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          SizedBox(height: width * 0.008),

                          Text(
                            widget.amount,
                            style: TextStyle(
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// 🔥 RIGHT SIDE (Status)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: widget.status == "Active"
                            ? Colors.green.withOpacity(0.12)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.status,
                        style: TextStyle(
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.w500,
                          color: widget.status == "Active"
                              ? Colors.green.shade700
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.015),

                /// 🔥 PROGRESS BAR
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: widget.progress,
                    minHeight: 6,
                    backgroundColor: AppColors.background,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _swipeBackground({
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color),
    );
  }
}