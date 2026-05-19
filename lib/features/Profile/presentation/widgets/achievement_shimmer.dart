import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';

class AchievementShimmerGrid extends StatelessWidget {
  final bool isGrid;
  final int itemCount;

  const AchievementShimmerGrid({
    super.key,
    required this.isGrid,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: itemCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, __) => const AchievementShimmerCard(),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const AchievementShimmerListItem(),
    );
  }
}

class AchievementShimmerCard extends StatelessWidget {
  const AchievementShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ShimmerContainer(
      height: 180,
    );
  }
}

class AchievementShimmerListItem extends StatelessWidget {
  const AchievementShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ShimmerContainer(
      height: 84,
    );
  }
}

class _ShimmerContainer extends StatefulWidget {
  final double height;

  const _ShimmerContainer({
    required this.height,
  });

  @override
  State<_ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<_ShimmerContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.border.withOpacity(_animation.value),
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}

