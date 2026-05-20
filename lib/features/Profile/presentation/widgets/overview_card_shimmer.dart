import 'package:flutter/material.dart';

/// Shimmer skeleton loading state for overview cards
/// Provides smooth placeholder while data is loading
class OverviewCardShimmer extends StatefulWidget {
  final bool isLandscape;

  const OverviewCardShimmer({
    super.key,
    this.isLandscape = false,
  });

  @override
  State<OverviewCardShimmer> createState() => _OverviewCardShimmerState();
}

class _OverviewCardShimmerState extends State<OverviewCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 12 : 16,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title Shimmer
            _ShimmerBox(
              width: 150,
              height: 16,
              borderRadius: 8,
              animation: _animationController,
            ),
            const SizedBox(height: 16),

            /// Grid of card shimmers
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width < 600 ? 2 : 4,
                crossAxisSpacing: isSmall ? 8 : 12,
                mainAxisSpacing: isSmall ? 8 : 12,
                childAspectRatio: 0.85,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _ShimmerCard(
                  animation: _animationController,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final AnimationController animation;

  const _ShimmerCard({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Icon placeholder
            _ShimmerBox(
              width: 40,
              height: 40,
              borderRadius: 12,
              animation: animation,
            ),
            const SizedBox(height: 8),

            /// Title placeholder
            _ShimmerBox(
              width: double.infinity,
              height: 12,
              borderRadius: 6,
              animation: animation,
            ),
            const SizedBox(height: 6),

            /// Value placeholder
            _ShimmerBox(
              width: double.infinity,
              height: 16,
              borderRadius: 8,
              animation: animation,
            ),
            const SizedBox(height: 8),

            /// Trend placeholder
            _ShimmerBox(
              width: 60,
              height: 10,
              borderRadius: 6,
              animation: animation,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final AnimationController animation;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final angle = animation.value * 360;
        return Transform.rotate(
          angle: angle * 3.14159 / 180,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade200,
                  Colors.grey.shade100,
                  Colors.grey.shade200,
                ],
                stops: [0, 0.5, 1],
              ),
            ),
          ),
        );
      },
    );
  }
}

