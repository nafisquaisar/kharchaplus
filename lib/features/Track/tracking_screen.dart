  import 'package:flutter/material.dart';
  import 'ElectricityTracking/presentation/screens/ElectricityTrackingScreen.dart';
  import 'FoodTracking/presentation/screens/food_tracking_screen.dart';
  import 'WaterTracking/WaterTrackingScreen.dart';
  import 'WaterTracking/presentation/screens/water_screen.dart';
import 'widgets/tracking_card.dart';


  class TrackingScreen extends StatefulWidget {
    const TrackingScreen({super.key});

    @override
    State<TrackingScreen> createState() => _TrackingScreenState();
  }

  class _TrackingScreenState extends State<TrackingScreen> {
    void openScreen(BuildContext context, String title) {
      if (title == "Food Tracking") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FoodTrackingScreen()),
        );
      } else if (title == "Electricity Tracking") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ElectricityTrackingScreen()),
        );
      } else if (title == "Water Tracking") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WaterScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$title not implemented yet")),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      final modules = [
        {
          "title": "Food Tracking",
          "subtitle": "1 Active • 4 Cycles",
          "amount": "₹ 4,200",
          "icon": Icons.restaurant,
          "color": Colors.green
        },
        {
          "title": "Electricity Tracking",
          "subtitle": "1 Active • 2 Cycles",
          "amount": "₹ 1,900",
          "icon": Icons.flash_on,
          "color": Colors.orange
        },
        {
          "title": "Water Tracking",
          "subtitle": "1 Active • 2 Cycles",
          "amount": "₹ 800",
          "icon": Icons.water_drop,
          "color": Colors.blue
        },
      ];

      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FF),

        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Tracking Modules",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...modules.map((e) => TrackingCard(
              title: e["title"] as String,
              subtitle: e["subtitle"] as String,
              amount: e["amount"] as String,
              icon: e["icon"] as IconData,
              color: e["color"] as Color,
              onTap: () =>{
                 setState(() {
                   openScreen(context, e["title"] as String);
                 }),
              }
            )),
          ],
        ),
      );
    }
  }