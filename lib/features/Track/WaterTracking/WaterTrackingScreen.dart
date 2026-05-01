import 'package:flutter/material.dart';

class WaterTrackingScreen extends StatelessWidget {
  const WaterTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Water Tracking")),
      body: const Center(child: Text("Water Tracking Screen")),
    );
  }
}