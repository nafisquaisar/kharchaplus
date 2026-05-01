import 'package:flutter/material.dart';

class OverviewHeader extends StatelessWidget {
  const OverviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Overview",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("This Month",
              style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}