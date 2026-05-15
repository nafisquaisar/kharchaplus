import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/AppColors.dart';

class HistorySummaryCard extends StatelessWidget {
  final DateTime selectedDate;
  final int totalMl;
  final int dailyGoalMl;

  const HistorySummaryCard({
    super.key,
    required this.selectedDate,
    required this.totalMl,
    required this.dailyGoalMl,
  });

  @override
  Widget build(BuildContext context) {
    final completion = dailyGoalMl == 0 ? 0.0 : totalMl / dailyGoalMl;
    final completionPercent = (completion * 100).clamp(0, 999).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppColors.kharchaGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, dd MMM yyyy').format(selectedDate),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalMl ml',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completionPercent% of daily goal',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _CompletionBadge(
            completionPercent: completionPercent,
          ),
        ],
      ),
    );
  }
}

class _CompletionBadge extends StatelessWidget {
  final int completionPercent;

  const _CompletionBadge({
    required this.completionPercent,
  });

  @override
  Widget build(BuildContext context) {
    final icon = completionPercent >= 100
        ? Icons.verified_rounded
        : completionPercent >= 50
            ? Icons.water_drop_rounded
            : Icons.pending_rounded;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
