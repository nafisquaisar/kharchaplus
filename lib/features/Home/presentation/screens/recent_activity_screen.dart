import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/Common/CommonAppBar.dart';
import '../../../../core/constants/AppColors.dart';
import '../../domain/entities/RecentActivityEntity.dart';
import '../providers/recent/recent_activity_providers.dart';
import '../utils/recent_activity_navigation_handler.dart';
import '../widgets/recent_activity/recent_activity_filter_sheet.dart';

class RecentActivityScreen extends ConsumerStatefulWidget {
  const RecentActivityScreen({super.key});

  @override
  ConsumerState<RecentActivityScreen> createState() =>
      _RecentActivityScreenState();
}

class _RecentActivityScreenState extends ConsumerState<RecentActivityScreen> {
  static const _filters = [
    'All',
    'Food',
    'Electricity',
    'Water',
  ];

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
    final recentState = ref.watch(
      recentActivityNotifierProvider,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: CommonAppBar(
          title: 'Recent Activity',
          isHome: false,
          isDashboard: false,
          showMore: true,
          moreIcon: Icons.filter_list_rounded ,
          onMenuTap: () {
            Navigator.pop(context);
          },
          onNotificationTap: () {
          },
          onMoreTap: (){
              _openFilterSheet();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// SEARCH BAR
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                14,
                16,
                10,
              ),
              child: _buildSearchBar(),
            ),

            const SizedBox(height: 14),

            /// LIST
            Expanded(
              child: recentState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => _buildErrorState(),
                data: (activities) {
                  final filtered = _filterActivities(
                    activities,
                  );

                  if (filtered.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: () async {
                      await ref
                          .read(
                            recentActivityNotifierProvider.notifier,
                          )
                          .loadRecentActivities();
                    },
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 24,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];

                        return GestureDetector(
                          onTap: () {
                            _navHandler.navigate(
                              context,
                              item,
                            );
                          },
                          child: _buildActivityCard(
                            item,
                          ),
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

  /// SEARCH BAR
  Widget _buildSearchBar() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) {
          setState(() {});
        },
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: "Search recent activity",
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.accent,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
        ),
      ),
    );
  }

  /// ACTIVITY CARD
  Widget _buildActivityCard(
    RecentActivityEntity item,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(
        4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(
          10,
        ),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          /// LEFT ICON
          Container(
            height: 44,
            width: 44,
            padding: const EdgeInsets.all(
              12,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Icon(
              _getIcon(
                item.type,
              ),
              size: 24,
              color: AppColors.accent,
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          /// CENTER DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                /// SUBTITLE
                /// SUBTITLE + DATE
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 10,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: item.subtitle,
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextSpan(
                              text: " • ${_formatDate(item.createdAt)}",
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                /// DATE
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 10,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      _formatDate(
                        item.createdAt,
                      ),
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          /// PRICE
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Text(
              "₹${item.amount}",
              style: textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// EMPTY
  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 70,
            color: AppColors.accent,
          ),
          const SizedBox(height: 14),
           Text(
            "No Recent Activity",
            style: textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Recent transactions appear here",
            style: textTheme.bodySmall?.copyWith(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// ERROR
  Widget _buildErrorState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 65,
            color: colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(
            "Something went wrong",
            style: textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Please try again",
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// FILTER
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
      (a, b) => b.createdAt.compareTo(
        a.createdAt,
      ),
    );

    return filtered;
  }

  /// FILTER BOTTOM SHEET
  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return RecentActivityFilterSheet(
          options: _filters,
          selected: _selectedFilter,
          onSelected: (value) {
            Navigator.pop(context);

            setState(() {
              _selectedFilter = value;
            });
          },
        );
      },
    );
  }

  /// ICONS
  IconData _getIcon(
    String type,
  ) {
    switch (type) {
      case 'food':
        return Icons.restaurant;

      case 'electricity':
        return Icons.bolt_rounded;

      case 'water_management':
      case 'water_intake':
        return Icons.water_drop_rounded;

      default:
        return Icons.receipt_long;
    }
  }

  /// DATE
  String _formatDate(
    DateTime date,
  ) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
