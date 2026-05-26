import 'package:flutter/material.dart';

/// Empty state widget for when no overview data is available
class OverviewEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final bool showRetryButton;

  const OverviewEmptyState({
    super.key,
    this.title = 'No data yet',
    this.message = 'Start tracking your expenses and utilities to see your monthly overview.',
    this.onRetry,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 20 : 30,
          vertical: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Illustration icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.analytics_outlined,
                size: 40,
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            /// Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmall ? 18 : 20,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            /// Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmall ? 13 : 14,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),

            if (showRetryButton && onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 24 : 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
