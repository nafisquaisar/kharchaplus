import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';
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
                  color: recentActivityBgColor(item.type),
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
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: width * 0.037,
                      ),
                    ),
                    SizedBox(height: width * 0.004),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: width * 0.029,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${item.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: AppColors.black,
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
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      height: 1,
      color: const Color(0xFFF1F3F5),
    );
  }
}

IconData recentActivityIcon(String type) {
  switch (type) {
    case 'electricity':
      return Icons.bolt_rounded;

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

Color recentActivityBgColor(String type) {
  switch (type) {
    case 'electricity':
      return const Color(0xFFFFF4E8);

    case 'expense':
      return const Color(0xFFFFF1F3);

    case 'food':
      return const Color(0xFFEEF4FF);

    case 'water_intake':
    case 'water_management':
      return const Color(0xFFEAF7F6);

    default:
      return Colors.grey.shade100;
  }
}

Color recentActivityIconColor(String type) {
  switch (type) {
    case 'electricity':
      return const Color(0xFFE58A00);

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
