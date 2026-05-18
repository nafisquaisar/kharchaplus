import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class RecentActivityEmptyState extends StatelessWidget {
  final String message;

  const RecentActivityEmptyState({
    super.key,
    this.message = 'No Recent Activity',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class RecentActivityErrorState extends StatelessWidget {
  final String message;

  const RecentActivityErrorState({
    super.key,
    this.message = 'Error loading recent activities',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class RecentActivityLoadingState extends StatelessWidget {
  const RecentActivityLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

