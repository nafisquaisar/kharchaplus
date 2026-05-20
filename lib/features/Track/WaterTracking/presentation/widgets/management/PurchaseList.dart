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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              const Text(
                'Recent Purchases',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
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
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.colorText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else if (error != null)
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'Failed to load purchases',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
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
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "No purchases yet",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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
                  color: Colors.grey.shade200,
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
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: AppColors.primarybg,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Image.asset(
                        item.type.iconPath,
                        fit: BoxFit.contain,
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
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            "${item.quantity} items",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            "${item.date.day}/${item.date.month}/${item.date.year}",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
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
