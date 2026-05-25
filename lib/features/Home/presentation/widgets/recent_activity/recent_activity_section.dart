import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/recent/recent_activity_providers.dart';
import '../../screens/recent_activity_screen.dart';
import '../../utils/recent_activity_navigation_handler.dart';
import 'recent_activity_list_item.dart';

class RecentActivitySection extends ConsumerWidget {
  const RecentActivitySection({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const navHandler = RecentActivityNavigationHandler();

    final recentState = ref.watch(
      recentActivityNotifierProvider,
    );

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
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          /// 🔥 HEADER
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Activity",
                style: textTheme.titleMedium?.copyWith(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),

              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecentActivityScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.025,
                    vertical: width * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                  child: Text(
                    "View All",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.03,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: width * 0.02),

          /// 🔥 DYNAMIC RECENT DATA
          recentState.when(
            loading: () => const SizedBox.shrink(),

            error: (e, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'Error loading recent activities',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

            data: (activities) {
              if (activities.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No Recent Activity',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }

              final limitedActivities =
              activities.length > 5
                  ? activities.take(5).toList()
                  : activities;

              return Column(
                children: List.generate(
                  limitedActivities.length,
                      (index) {
                    final item =
                    limitedActivities[index];

                    return Column(
                      children: [
                        RecentActivityListItem(
                          item: item,
                          width: width,
                          onTap: () => navHandler.navigate(context, item),
                        ),

                        if (index !=
                            limitedActivities
                                .length -
                                1)
                          const RecentActivityDivider(),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}