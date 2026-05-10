import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

class SummaryRow extends StatelessWidget {
  final int totalMeals;

  final int lunch;

  final int dinner;

  final int remaining;

  final double cost;

  final int totalTiffin;

  const SummaryRow({
    super.key,

    required this.totalMeals,

    required this.lunch,

    required this.dinner,

    required this.remaining,

    required this.cost,

    required this.totalTiffin,
  });

  double get progress {
    if (totalTiffin == 0) {
      return 0;
    }

    return (totalMeals / totalTiffin) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        gradient: AppColors.kharchaGradient,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.16),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          // =========================
          // TOP STATS
          // =========================
          Row(
            children: [
              Expanded(child: _item("Meals", "$totalMeals", Icons.restaurant)),

              Expanded(
                child: _item("Left", "$remaining", Icons.inventory_2_outlined),
              ),

              Expanded(
                child: _item(
                  "Done",
                  "${progress.toStringAsFixed(0)}%",
                  Icons.trending_up,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================
          // PROGRESS BAR
          // =========================
          ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: LinearProgressIndicator(
              value: progress / 100,

              minHeight: 5,

              backgroundColor: Colors.white24,

              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),

          const SizedBox(height: 10),

          // =========================
          // MINI CARDS
          // =========================
          Row(
            children: [
              Expanded(child: _miniCard("Lunch", "$lunch")),

              const SizedBox(width: 8),

              Expanded(child: _miniCard("Dinner", "$dinner")),

              const SizedBox(width: 8),

              Expanded(child: _miniCard("Cost", "₹${cost.toStringAsFixed(0)}")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(
      String title,
      String value,
      IconData icon,
      ) {

    return Column(

      mainAxisSize: MainAxisSize.min,

      children: [

        // =========================
        // ICON + VALUE
        // =========================

        Row(

          mainAxisAlignment:
          MainAxisAlignment.center,

          mainAxisSize:
          MainAxisSize.min,

          children: [

            Icon(
              icon,
              color: Colors.white,
              size: 14,
            ),

            const SizedBox(width: 4),

            Text(

              value,

              style: const TextStyle(

                color: Colors.white,

                fontSize: 15,

                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 2),

        // =========================
        // TITLE
        // =========================

        Text(

          title,

          style: const TextStyle(

            color: Colors.white70,

            fontSize: 10,

            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _miniCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          Text(
            value,

            style: const TextStyle(
              color: Colors.white,

              fontSize: 13,

              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 1),

          Text(
            title,

            style: const TextStyle(color: Colors.white70, fontSize: 9),
          ),
        ],
      ),
    );
  }
}
