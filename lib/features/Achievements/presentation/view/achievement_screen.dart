import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/Common/CommonAppBar.dart';
import '../../../../core/constants/AppColors.dart';
import '../viewmodel/profile_achievement_viewmodel.dart';
import '../../../Profile/services/achievement_catalog.dart';
import '../widgets/achievement_card.dart';
import '../widgets/achievement_empty_state.dart';
import '../widgets/achievement_shimmer.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  bool _isGrid = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileAchievementViewModel>().evaluateAndSync();
    });
  }

  Future<void> _refresh(ProfileAchievementViewModel vm) async {
    await vm.refreshFromRemote();
    await vm.evaluateAndSync();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileAchievementViewModel>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CommonAppBar(
          title: "Achievements",
          isHome: false,
          isDashboard: false,

          onMenuTap: () {
            Navigator.pop(context);
          },

          onNotificationTap: () {},

          showMore: true,

          moreIcon: _isGrid
              ? Icons.view_list_rounded
              : Icons.grid_view_rounded,

          onMoreTap: () {
            setState(() => _isGrid = !_isGrid);
          },
        ),
      ),
      body: Column(
        children: [
          _CategoryTabs(
            selected: vm.selectedCategory,
            onSelected: vm.setCategory,
          ),
          _SummaryHeader(
            unlocked: vm.unlockedCount,
            total: vm.items.length,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildBody(vm),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ProfileAchievementViewModel vm) {
    if (vm.isBusy && vm.items.isEmpty) {
      return AchievementShimmerGrid(isGrid: _isGrid);
    }

    if (vm.filteredItems.isEmpty) {
      return AchievementEmptyState(
        onRefresh: () => _refresh(vm),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _refresh(vm),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width >= 900
              ? 3
              : width >= 600
                  ? 2
                  : 2;

          if (_isGrid) {
            final cardHeight = width >= 900
                ? 270.0
                : width >= 600
                    ? 248.0
                    : 230.0;

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: vm.filteredItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisExtent: cardHeight,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return AchievementCard(
                  achievement: vm.filteredItems[index],
                );
              },
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: vm.filteredItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return AchievementListItem(
                achievement: vm.filteredItems[index],
              );
            },
          );
        },
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final int unlocked;
  final int total;

  const _SummaryHeader({
    required this.unlocked,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$unlocked of $total unlocked',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'Progress',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.colorText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final AchievementCategory? selected;
  final ValueChanged<AchievementCategory?> onSelected;

  const _CategoryTabs({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = AchievementCategory.values;

    return SizedBox(
      height: 52,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        scrollDirection: Axis.horizontal,
        children: [
          _TabChip(
            label: 'All',
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final category in categories)
            _TabChip(
              label: _label(category),
              isSelected: selected == category,
              onTap: () => onSelected(category),
            ),
        ],
      ),
    );
  }

  String _label(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.water:
        return 'Water';
      case AchievementCategory.electricity:
        return 'Electricity';
      case AchievementCategory.expense:
        return 'Expense';
      case AchievementCategory.savings:
        return 'Savings';
      case AchievementCategory.streak:
        return 'Streak';
    }
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final background = isSelected ? AppColors.accent : AppColors.card;
    final textColor = isSelected ? Colors.white : AppColors.colorText;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
