import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/AppColors.dart';

import '../../providers/purchase/purchase_provider.dart';
import '../../providers/filters/expense_filter_provider.dart';
import '../../screens/purchase_history_screen.dart';
import '../../../domain/enum/purchase_type.dart';

class PurchaseList extends ConsumerWidget {
  const PurchaseList({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state = ref.watch(
      purchaseNotifierProvider,
    );

    final purchases = ref.watch(
      filteredPurchasesProvider,
    );
    final latestPurchases = [...purchases]
      ..sort((a, b) => b.date.compareTo(a.date));

    final recentFivePurchases = latestPurchases.take(5).toList();

    final isLoading = state.isLoading;
    final error = state.error;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // HEADER
          // =========================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                'Recent Purchases',
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WaterPurchaseHistoryScreen(),
                    ),
                  );
                },
                child:  Text(
                  'View All',
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (isLoading)
             Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else if (error != null)
             Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'Failed to load purchases',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // =========================
          // EMPTY STATE
          // =========================

          if (purchases.isEmpty && !isLoading && error == null)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.water_drop_outlined,
                      size: 40,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "No purchases yet",
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else

            // =========================
            // LIST
            // =========================

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentFivePurchases.length,
              separatorBuilder: (context, index) {
                return Divider(
                  color: colorScheme.outlineVariant,
                  height: 18,
                );
              },
              itemBuilder: (context, index) {
                final item = recentFivePurchases[index];
                return Row(
                  children: [
                    // =========================
                    // ICON
                    // =========================

                    Container(
                      height: 50,
                      width: 50,

                      decoration: BoxDecoration(

                        color: colorScheme.surfaceContainerHighest,

                        borderRadius:
                        BorderRadius.circular(20),
                      ),

                      child: ClipRRect(

                        borderRadius:
                        BorderRadius.circular(20),

                        child: Image.asset(

                          item.type.iconPath,

                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    // =========================
                    // TEXT
                    // =========================

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.displayTypeName,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            "${item.quantity} items",
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            "${item.date.day}/${item.date.month}/${item.date.year}",
                            style: textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    // =========================
                    // PRICE
                    // =========================

                    Text(
                      "₹${item.price}",
                      style: textTheme.titleSmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
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
}
