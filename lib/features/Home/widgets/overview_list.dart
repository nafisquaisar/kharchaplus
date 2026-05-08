import 'package:flutter/material.dart';
import 'overview_item.dart';

class OverviewList extends StatelessWidget {
  const OverviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).padding.bottom + 80,
      ),

      children: const [
        OverviewItem(
          title: "Expense",
          subtitle: "2 Cycles • 18 Items",
          amount: "₹ 12,450",
          icon: Icons.account_balance_wallet,
        ),
        OverviewItem(
          title: "Food Tracking",
          subtitle: "Jan 5 - Feb 4",
          amount: "₹ 4,200",
          icon: Icons.restaurant,
        ),
        OverviewItem(
          title: "Electricity",
          subtitle: "Jan 5 - Feb 4",
          amount: "₹ 1,900",
          icon: Icons.flash_on,
        ),
        OverviewItem(
          title: "Water",
          subtitle: "Jan 5 - Feb 4",
          amount: "₹ 800",
          icon: Icons.water_drop,
        ),
        OverviewItem(
          title: "Other Tracking",
          subtitle: "2 Active",
          amount: "₹ 1,250",
          icon: Icons.category,
        ),
        OverviewItem(
          title: "Friend Balance",
          subtitle: "You Owe: ₹2000",
          amount: "₹ 1,500",
          icon: Icons.people,
        ),
      ],
    );
  }
}