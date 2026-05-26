import 'package:flutter/material.dart';

import '../../data/models/tracking_model.dart';

class TrackingCard extends StatelessWidget {
  final TrackingModel tracking;

  final VoidCallback? onTap;

  const TrackingCard({
    super.key,
    required this.tracking,
    this.onTap,
  });

  /// =========================================
  /// DYNAMIC ICON
  /// =========================================

  IconData getTrackingIcon() {
    switch (tracking.iconType.toLowerCase()) {
      case "food":
        return Icons.fastfood_rounded;

      case "water":
        return Icons.water_drop_rounded;

      case "electricity":
        return Icons.bolt_rounded;

      default:
        return Icons.track_changes_rounded;
    }
  }

  /// =========================================
  /// DYNAMIC COLOR
  /// =========================================

  Color getTrackingColor() {
    switch (tracking.iconType.toLowerCase()) {
      case "food":
        return Colors.orange;

      case "water":
        return Colors.blue;

      case "electricity":
        return Colors.amber;

      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getTrackingColor();
    final icon = getTrackingIcon();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            /// ===============================
            /// TOP ROW
            /// ===============================

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${tracking.type} Tracking",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${tracking.activeCycles} Active Cycles",
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹ ${tracking.totalAmount.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tracking.isActive
                            ? Colors.green.withOpacity(0.12)
                            : Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        tracking.status,
                        style: TextStyle(
                          color: tracking.isActive ? Colors.green : Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// ===============================
            /// PROGRESS BAR
            /// ===============================

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: tracking.progressPercent,
                minHeight: 7,
                backgroundColor: color.withOpacity(0.10),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),

            const SizedBox(height: 12),

            /// ===============================
            /// BOTTOM STATS
            /// ===============================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  context,
                  "Today",
                  "₹ ${tracking.todayAmount.toStringAsFixed(0)}",
                ),
                _buildStatItem(
                  context,
                  "Monthly",
                  "₹ ${tracking.monthlyAmount.toStringAsFixed(0)}",
                ),
                _buildStatItem(
                  context,
                  "Records",
                  tracking.totalRecords.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
