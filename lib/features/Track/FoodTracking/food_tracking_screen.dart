import 'package:flutter/material.dart';
import '../model/FoodCycle.dart';
import 'widgets/food_cycle_card.dart';
import 'bottomsheet/create_food_cycle_sheet.dart';
import 'food_tracking_detail_screen.dart';

class FoodTrackingScreen extends StatefulWidget {
  const FoodTrackingScreen({super.key});

  @override
  State<FoodTrackingScreen> createState() =>
      _FoodTrackingScreenState();
}

class _FoodTrackingScreenState extends State<FoodTrackingScreen> {

  // ✅ Use MODEL instead of Map
  List<FoodCycle> cycles = [
    FoodCycle(
      id: "1",
      price: 75,
      startDate: DateTime(2024, 1, 5),
      endDate: DateTime(2024, 2, 4),
      sundayRule: "2 Meals",
    ),
    FoodCycle(
      id: "2",
      price: 70,
      startDate: DateTime(2023, 12, 5),
      endDate: DateTime(2024, 1, 4),
      sundayRule: "1 Meal",
      status: "Completed",
    ),
  ];

  // 🔥 OPEN BOTTOM SHEET
  void openCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CreateFoodCycleSheet(
        onCreate: (FoodCycle cycle) {
          setState(() {
            cycles.add(cycle);
          });
        },
      ),
    );
  }

  // 🔥 OPEN DETAIL
    void openDetail(FoodCycle cycle) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FoodTrackingDetailScreen(cycle: cycle),
        ),
      );
    }

  // 🔥 CALCULATE COST (dynamic)
  String calculateCost(FoodCycle cycle) {
    // For now dummy calculation (you'll replace later)
    return "₹ ${(cycle.price * 56).toStringAsFixed(0)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),

      appBar: AppBar(
        title: const Text("Food Tracking"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Your Food Tracking Cards",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // 🔥 LIST
          ...cycles.map((cycle) => FoodCycleCard(
            title: cycle.title,
            cost: calculateCost(cycle),
            status: cycle.status,
            highlight: cycle.status == "Active",
            onTap: () => openDetail(cycle),
          )),
        ],
      ),

      // 🔥 FAB
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}