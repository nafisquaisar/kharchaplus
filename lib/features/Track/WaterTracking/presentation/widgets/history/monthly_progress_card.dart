import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

class MonthlyProgressCard extends StatelessWidget {
  final int consumedMl;
  final int targetMl;
  final int remainingMl;
  final double progress;

  const MonthlyProgressCard({
    super.key,
    required this.consumedMl,
    required this.targetMl,
    required this.remainingMl,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Monthly Goal Progress',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MetricChip(
                label: 'Consumed',
                value: '${consumedMl ~/ 1000}L',
              ),
              _MetricChip(
                label: 'Target',
                value: '${targetMl ~/ 1000}L',
              ),
              _MetricChip(
                label: 'Remaining',
                value: '${remainingMl ~/ 1000}L',
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0,
              end: progress.clamp(0.0, 1.0),
            ),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: value,
                  backgroundColor: AppColors.primarybg,
                  valueColor:  AlwaysStoppedAnimation<Color>(
                    AppColors.accent,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;

  const _MetricChip({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarybg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style:  TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style:  TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
