import 'package:flutter/material.dart';

import '../../../domain/entities/RecentActivityEntity.dart';

class RecentActivityListItem extends StatelessWidget {
  final RecentActivityEntity item;
  final double width;
  final VoidCallback? onTap;

  const RecentActivityListItem({
    super.key,
    required this.item,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: width * 0.012,
          ),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: recentActivityBgColor(context, item.type),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  recentActivityIcon(item.type),
                  color: recentActivityIconColor(item.type),
                  size: width * 0.05,
                ),
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: width * 0.037,
                      ),
                    ),
                    SizedBox(height: width * 0.004),
                    Text(
                      item.subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: width * 0.029,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${item.amount.toStringAsFixed(0)}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: width * 0.038,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentActivityDivider extends StatelessWidget {
  const RecentActivityDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      height: 1,
      color: colorScheme.outlineVariant,
    );
  }
}

IconData recentActivityIcon(String type) {
  switch (type) {
    case 'electricity':
      return Icons.bolt_rounded;

    case 'expense_cycle':
      return Icons.folder_rounded;

    case 'expense_item':
      return Icons.payments_rounded;

    case 'expense':
      return Icons.account_balance_wallet_rounded;

    case 'food':
      return Icons.restaurant_rounded;

    case 'water_intake':
      return Icons.water_drop_rounded;

    case 'water_management':
      return Icons.local_drink_rounded;

    default:
      return Icons.history_rounded;
  }
}

Color recentActivityBgColor(BuildContext context, String type) {
  final colorScheme = Theme.of(context).colorScheme;
  switch (type) {
    case 'electricity':
      return const Color(0xFFE58A00).withOpacity(0.12);

    case 'expense_cycle':
    case 'expense_item':
    case 'expense':
      return const Color(0xFFE11D48).withOpacity(0.12);

    case 'food':
      return const Color(0xFF2563EB).withOpacity(0.12);

    case 'water_intake':
    case 'water_management':
      return const Color(0xFF2D8C82).withOpacity(0.12);

    default:
      return colorScheme.surfaceContainerHighest;
  }
}

Color recentActivityIconColor(String type) {
  switch (type) {
    case 'electricity':
      return const Color(0xFFE58A00);

    case 'expense_cycle':
    case 'expense_item':
    case 'expense':
      return const Color(0xFFE11D48);

    case 'food':
      return const Color(0xFF2563EB);

    case 'water_intake':
    case 'water_management':
      return const Color(0xFF2D8C82);

    default:
      return Colors.grey;
  }
}
