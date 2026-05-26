import 'package:flutter/material.dart';

/// Reusable Overview Card widget for displaying metrics
/// Shows: icon, title, value, trend percentage, and status indicator
/// Features: smooth animations, responsive design, soft shadows
class OverviewCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String trendPercentage;
  final bool isTrendPositive;
  final VoidCallback? onTap;
  final bool isLoading;
  final Duration animationDuration;

  const OverviewCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.trendPercentage,
    required this.isTrendPositive,
    this.onTap,
    this.isLoading = false,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  State<OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<OverviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(OverviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading && !widget.isLoading) {
      _animationController.forward(from: 0.7);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getTrendColor() {
    if (widget.trendPercentage.isEmpty || widget.trendPercentage == '0%') {
      return Theme.of(context).colorScheme.onSurfaceVariant;
    }
    return widget.isTrendPositive ? Colors.green.shade500 : Colors.red.shade500;
  }

  IconData _getTrendIcon() {
    if (widget.trendPercentage.isEmpty || widget.trendPercentage == '0%') {
      return Icons.remove;
    }
    return widget.isTrendPositive
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  /// Soft shadow - key to premium feel
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(_isHovered ? 0.12 : 0.08),
                    blurRadius: _isHovered ? 16 : 12,
                    spreadRadius: 0,
                    offset: Offset(0, _isHovered ? 6 : 4),
                  ),
                  /// Subtle inner highlight
                  BoxShadow(
                    color: colorScheme.surface.withOpacity(0.6),
                    blurRadius: 2,
                    spreadRadius: 0,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(isSmall ? 12 : 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header row: Icon + Trend indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Icon container with gradient background
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.iconColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.iconColor,
                            size: isSmall ? 18 : 20,
                          ),
                        ),

                        /// Trend badge
                        if (widget.trendPercentage.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmall ? 6 : 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getTrendColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getTrendIcon(),
                                  color: _getTrendColor(),
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  widget.trendPercentage,
                                  style: TextStyle(
                                    fontSize: isSmall ? 10 : 11,
                                    fontWeight: FontWeight.w700,
                                    color: _getTrendColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// Title
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmall ? 12 : 13,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// Value - Main metric
                    Text(
                      widget.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmall ? 16 : 18,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// Divider
                    Container(
                      height: 0.5,
                      color: colorScheme.outlineVariant,
                    ),

                    const SizedBox(height: 6),

                    /// Footer - Additional info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'This month',
                          style: TextStyle(
                            fontSize: isSmall ? 10 : 11,
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (widget.onTap != null)
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Variant: Compact overview card for limited space
class CompactOverviewCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String? trendPercentage;
  final bool isTrendPositive;

  const CompactOverviewCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.trendPercentage,
    required this.isTrendPositive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

