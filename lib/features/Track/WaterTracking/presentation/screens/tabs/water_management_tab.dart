import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/management/expense_summary_card.dart';
import '../../widgets/management/PurchaseList.dart';
import '../../widgets/management/quick_purchase_type.dart';
import '../../providers/purchase/purchase_provider.dart';

class WaterManagementTab extends ConsumerStatefulWidget {
  const WaterManagementTab({
    super.key,
  });

  @override
  ConsumerState<WaterManagementTab> createState() => _WaterManagementTabState();
}

class _WaterManagementTabState extends ConsumerState<WaterManagementTab> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(purchaseNotifierProvider.notifier).loadPurchases();
    });
  }


  @override
  Widget build(BuildContext context) {

    return CustomScrollView(

      physics:
      const BouncingScrollPhysics(),

      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior
          .onDrag,

      slivers: [

        SliverPadding(

          padding:
          const EdgeInsets.only(

            left: 16,
            right: 16,
            bottom: 100,
          ),

          sliver: SliverList(

            delegate:
            SliverChildListDelegate(

              const [

                ExpenseSummaryCard(),

                SizedBox(height: 16),

                PurchaseList(),

                SizedBox(height: 16),

                QuickPurchaseType(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}