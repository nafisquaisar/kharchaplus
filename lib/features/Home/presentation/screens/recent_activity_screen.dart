import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/Common/CommonAppBar.dart';
import '../../../../core/constants/AppColors.dart';
import '../../domain/entities/RecentActivityEntity.dart';
import '../providers/recent/recent_activity_providers.dart';
import '../widgets/recent_activity/recent_activity_filter_sheet.dart';
import '../widgets/recent_activity/recent_activity_list_item.dart';
import '../widgets/recent_activity/recent_activity_search_bar.dart';
import '../widgets/recent_activity/recent_activity_states.dart';
import '../utils/recent_activity_navigation_handler.dart';

class RecentActivityScreen extends ConsumerStatefulWidget {
  const RecentActivityScreen({super.key});

  @override
  ConsumerState<RecentActivityScreen> createState() => _RecentActivityScreenState();
}

class _RecentActivityScreenState extends ConsumerState<RecentActivityScreen> {
  static const _filters = <String>['All', 'Food', 'Electricity', 'Water'];
  static const _navHandler = RecentActivityNavigationHandler();

  late final TextEditingController _searchController;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final recentState = ref.watch(recentActivityNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CommonAppBar(
          title: 'Recent Activity',
          isHome: false,
          isDashboard: false,
          showMore: true,
          moreIcon: Icons.filter_list_rounded,
          onMenuTap: () {
            Navigator.pop(context);
          },
          onNotificationTap: () {},
          onMoreTap: () {
            _openFilterSheet();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: RecentActivitySearchBar(
                controller: _searchController,
                onChanged: (value) {
                  debugPrint('[RecentActivity] search="$value"');
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: recentState.when(
                loading: () => const RecentActivityLoadingState(),
                error: (e, _) => RecentActivityErrorState(
                  message: e.toString().isEmpty
                      ? 'Error loading recent activities'
                      : e.toString(),
                ),
                data: (activities) {
                  final filtered = _filterActivities(activities);
                  if (filtered.isEmpty) {
                    return const RecentActivityEmptyState(
                      message: 'No recent activities found',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      debugPrint('[RecentActivity] pull-to-refresh');
                      await ref
                          .read(recentActivityNotifierProvider.notifier)
                          .loadRecentActivities();
                    },
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const RecentActivityDivider(),
                      itemBuilder: (context, index) {
                        return RecentActivityListItem(
                          item: filtered[index],
                          width: width,
                          onTap: () => _navHandler.navigate(context, filtered[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return RecentActivityFilterSheet(
          options: _filters,
          selected: _selectedFilter,
          onSelected: (value) {
            debugPrint('[RecentActivity] filter="$value"');
            Navigator.pop(context);
            setState(() {
              _selectedFilter = value;
            });
          },
        );
      },
    );
  }

  List<RecentActivityEntity> _filterActivities(
    List<RecentActivityEntity> activities,
  ) {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = activities.where((item) {
      if (_selectedFilter == 'Food' && item.type != 'food') {
        return false;
      }
      if (_selectedFilter == 'Electricity' && item.type != 'electricity') {
        return false;
      }
      if (_selectedFilter == 'Water' &&
          item.type != 'water_management' &&
          item.type != 'water_intake') {
        return false;
      }

      if (query.isEmpty) {
        return true;
      }

      return item.title.toLowerCase().contains(query) ||
          item.subtitle.toLowerCase().contains(query);
    }).toList();

    filtered.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    return filtered;
  }
}
