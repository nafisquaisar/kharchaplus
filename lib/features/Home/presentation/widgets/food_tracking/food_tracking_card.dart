import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Track/FoodTracking/presentation/screens/food_tracking_screen.dart';
import '../../../domain/entities/food_tracking_entity.dart';
import '../../providers/food_tracking/food_tracking_home_providers.dart';

class FoodTrackingCard extends ConsumerStatefulWidget {
  const FoodTrackingCard({
    super.key,
  });

  @override
  ConsumerState<FoodTrackingCard> createState() => _FoodTrackingCardState();
}

class _FoodTrackingCardState extends ConsumerState<FoodTrackingCard> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(foodTrackingHomeNotifierProvider);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: 6,
      ),
      padding: EdgeInsets.all(
        width * 0.03,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 TOP ROW
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FoodTrackingScreen(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE58A00).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.restaurant_rounded,
                        size: 16,
                        color: Color(0xFFE58A00),
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    Text(
                      "Food Tracking",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: width * 0.065,
                ),
              ],
            ),
          ),

          SizedBox(height: width * 0.02),

          state.when(
            loading: () => _EmptyContent(
              width: width,
            ),
            error: (e, _) => _ErrorContent(width: width, message: e.toString()),
            data: (items) {
              final active = _filterAndSort(items);
              debugPrint('[FoodHomeCard] active cycles=${active.length}');

              if (active.isEmpty) {
                return _EmptyContent(width: width);
              }

              if (active.length == 1) {
                debugPrint('[FoodHomeCard] latest active=${active.first.id}');
                return _FoodCycleContent(
                  width: width,
                  cycle: active.first,
                );
              }

              debugPrint('[FoodHomeCard] slider count=${active.length}');
              return Column(
                children: [
                  SizedBox(
                    height: width * 0.36,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: active.length,
                      onPageChanged: (index) {
                        setState(() {
                          _pageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _FoodCycleContent(
                          width: width,
                          cycle: active[index],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: width * 0.01,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        active.length,
                        (index) => _IndicatorDot(
                          isActive: index == _pageIndex,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<FoodTrackingHomeEntity> _filterAndSort(
    List<FoodTrackingHomeEntity> items,
  ) {
    final active = items.where((item) => item.isActive).toList();
    active.sort(
      (a, b) {
        final updated = b.updatedAt.compareTo(a.updatedAt);
        if (updated != 0) {
          return updated;
        }
        return b.createdAt.compareTo(a.createdAt);
      },
    );
    return active;
  }
}

class _IndicatorDot extends StatelessWidget {
  final bool isActive;

  const _IndicatorDot({
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 8 : 5,
      height: 5,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE58A00) : colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}


class _ErrorContent extends StatelessWidget {
  final double width;
  final String message;

  const _ErrorContent({
    required this.width,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return _FoodCycleContent(
      width: width,
      cycle: FoodTrackingHomeEntity(
        id: 'error',
        title: 'Food Tracking',
        totalTiffin: 0,
        totalEaten: 0,
        remainingTiffin: 0,
        monthlyAmount: 0,
        mealPrice: 0,
        status: 'active',
        createdAt: DateTime(2020),
        updatedAt: DateTime(2020),
      ),
      forceProgress: 0,
      progressTextOverride: '--',
      amountOverride: '₹--',
      totalOverride: ' / ₹--',
      mealsLeftLabel: message.isEmpty ? 'Failed to load' : message,
    );
  }
}

class _EmptyContent extends StatelessWidget {
  final double width;

  const _EmptyContent({
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return _FoodCycleContent(
      width: width,
      cycle: FoodTrackingHomeEntity(
        id: 'empty',
        title: 'No Active Mess',
        totalTiffin: 0,
        totalEaten: 0,
        remainingTiffin: 0,
        monthlyAmount: 0,
        mealPrice: 0,
        status: 'inactive',
        createdAt: DateTime(2020),
        updatedAt: DateTime(2020),
      ),
      forceProgress: 0,
      progressTextOverride: '0%',
      amountOverride: '₹0',
      totalOverride: ' / ₹0',
      mealsLeftLabel: 'No active cycles',
    );
  }
}

class _FoodCycleContent extends StatelessWidget {
  final double width;
  final FoodTrackingHomeEntity cycle;
  final double? forceProgress;
  final String? progressTextOverride;
  final String? amountOverride;
  final String? totalOverride;
  final String? mealsLeftLabel;

  const _FoodCycleContent({
    required this.width,
    required this.cycle,
    this.forceProgress,
    this.progressTextOverride,
    this.amountOverride,
    this.totalOverride,
    this.mealsLeftLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final progressValue = forceProgress ?? cycle.progress;
    final progressText = progressTextOverride ?? '${cycle.progressPercent}%';
    final spentAmount = (cycle.totalEaten * cycle.mealPrice)
        .clamp(0, cycle.monthlyAmount)
        .toDouble();
    final amountText = amountOverride ?? '₹${spentAmount.toStringAsFixed(0)}';
    final totalText = totalOverride ?? ' / ₹${cycle.monthlyAmount.toStringAsFixed(0)}';
    final mealsLeft = mealsLeftLabel ?? '${cycle.remainingTiffin} Meals Left';

    return Container(
      margin: EdgeInsets.only(
        top: width * 0.01,
        bottom: width * 0.015,
        left: width * 0.02,
        right: width * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Active Mess",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: width * 0.033,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: width * 0.002),
                    Text(
                      cycle.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: width * 0.003),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.022,
                        vertical: width * 0.007,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE58A00).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        mealsLeft,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFFE58A00),
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: width * 0.16,
                width: width * 0.16,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: width * 0.16,
                      width: width * 0.16,
                      child: CircularProgressIndicator(
                        value: progressValue,
                        strokeWidth: 4,
                        backgroundColor: colorScheme.outlineVariant,
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFFE58A00),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          progressText,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.038,
                          ),
                        ),
                        Text(
                          "Completed",
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: width * 0.019,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: width * 0.012),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: amountText,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: width * 0.055,
                  ),
                ),
                TextSpan(
                  text: totalText,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.04,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: width * 0.015),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 4,
              backgroundColor: colorScheme.outlineVariant,
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFFE58A00),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
