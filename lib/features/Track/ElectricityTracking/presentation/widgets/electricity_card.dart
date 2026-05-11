import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../domain/entities/electricity_entity.dart';
import 'electricity_amount.dart';
import 'electricity_card_header.dart';
import 'electricity_stats.dart';
import 'electricity_status_badge.dart';

class ElectricityCard extends StatelessWidget {
  final ElectricityEntity entity;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ElectricityCard({
    super.key,
    required this.entity,
    this.onTap,
    this.onLongPress,
  });

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final dateRange =
        '${_formatDate(entity.startDate)} → ${_formatDate(entity.endDate)}';

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElectricityCardHeader(
              title: entity.displayTitle,
              subtitle: dateRange,
              trailing: ElectricityStatusBadge(entity: entity),
            ),
            const SizedBox(height: 8),
            ElectricityAmountSection(label: 'Total Bill', amount: entity.total),
            const SizedBox(height: 8),
            ElectricityStatsSection(
              items: [
                ElectricityStatItem(label: 'Prev', value: '${entity.prevUnit}'),
                ElectricityStatItem(label: 'Current', value: '${entity.currentUnit}',),
                ElectricityStatItem(label: 'Used', value: '${entity.consumed}'),
                ElectricityStatItem(label: 'Rate', value: '₹${entity.rate.toStringAsFixed(1)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
