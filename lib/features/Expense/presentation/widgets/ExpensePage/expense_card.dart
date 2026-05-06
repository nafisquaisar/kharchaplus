import 'package:flutter/material.dart';
import '../../../../../core/constants/KharchaThemeColors.dart';
import '../../../../../core/constants/colors.dart';

class ExpenseCard extends StatefulWidget {
  final String title;
  final String amount;
  final String items;
  final String status;
  final bool isHighlighted;
  final double progress;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final String subtitle;

  const ExpenseCard({
    super.key,
    required this.title,
    required this.amount,
    required this.items,
    required this.status,
    this.isHighlighted = false,
    this.progress = 0.5,
    this.onTap,
    this.onDelete,
    this.onEdit,
    required this.subtitle,
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

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,

      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),

        child: Container(
          margin: EdgeInsets.only(bottom: width * 0.02),
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: width * 0.02,
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
                color: Colors.black.withOpacity(0.09),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorText,
                      ),
                    ),
                  ),
                  if (widget.items.isNotEmpty)
                    Text(
                      widget.items,
                      style: TextStyle(
                        fontSize: width * 0.032,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: width * 0.032,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.025,
                      vertical: 4,
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

              const SizedBox(height: 6),

              const Text("Total Expense"),

              Text(
                "₹${widget.amount}",
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              LinearProgressIndicator(value: widget.progress),
            ],
          ),
        ),
      ),
    );
  }





}
