import 'package:flutter/material.dart';
import '../FoodDetailScreen.dart';
import '../viewmodel/profile_view_model.dart';
import '../widgets/stats_card.dart';

class SummaryGrid extends StatelessWidget {
  final ProfileViewModel vm;

  const SummaryGrid({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.1,
        children: [

          /// 💰 TOTAL EXPENSE
          StatsCard(
            title: "Total Expense",
            value: vm.totalExpense,
            icon: Icons.currency_rupee,
            color: Colors.green,
          ),

          /// 🍔 FOOD EXPENSE (CLICKABLE)
          StatsCard(
            title: "Food Expense",
            value: vm.foodExpense,
            icon: Icons.fastfood,
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  FoodDetailScreen(),
                ),
              );
            },
          ),

          /// 💧 WATER AVG
          StatsCard(
            title: "Water Avg",
            value: vm.waterAvg,
            icon: Icons.water_drop,
            color: Colors.blue,
          ),

          /// 🔥 STREAK
          StatsCard(
            title: "Streak",
            value: vm.streak,
            icon: Icons.local_fire_department,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}