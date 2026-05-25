import 'package:flutter/material.dart';
import '../../../../../core/constants/AppColors.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isHighlighted
                  ? AppColors.primary.withOpacity(0.3)
                  : colorScheme.outlineVariant,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.09),
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
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (widget.items.isNotEmpty)
                    Text(
                      widget.items,
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: width * 0.032,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: width * 0.032,
                      color: colorScheme.onSurfaceVariant,
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
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.status,
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.w500,
                        color: widget.status == "Active"
                            ? Colors.green.shade700
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                "Total Expense",
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              Text(
                "₹${widget.amount}",
                style: textTheme.titleMedium?.copyWith(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 6),

              LinearProgressIndicator(
                value: widget.progress,
                backgroundColor: colorScheme.outlineVariant,
                valueColor: AlwaysStoppedAnimation(AppColors.accent),
              ),
            ],
          ),
        ),
      ),
    );
  }





}
