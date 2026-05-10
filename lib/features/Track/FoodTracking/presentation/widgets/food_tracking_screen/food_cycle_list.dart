import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/FoodCycle.dart';
import '../../../domain/enum/cycle_status.dart';

import 'food_cycle_card.dart';

class FoodCycleList extends StatelessWidget {

  final List<FoodCycle> cycles;

  final Function(FoodCycle) onTap;

  const FoodCycleList({
    super.key,
    required this.cycles,
    required this.onTap,
  });

  // =========================
  // FORMAT AMOUNT
  // =========================

  String calculateCost(
      FoodCycle cycle,
      ) {

    return "₹ ${cycle.monthlyAmount.toStringAsFixed(0)}";
  }

  // =========================
  // FORMAT DATE
  // =========================

  String formatDateRange(
      FoodCycle cycle,
      ) {

    final start =
    DateFormat("d MMM")
        .format(cycle.startDate);

    final end =
    DateFormat("d MMM")
        .format(cycle.endDate);

    return "$start - $end";
  }

  // =========================
  // CARD STATUS
  // =========================

  bool isActive(
      FoodCycle cycle,
      ) {

    return cycle.status ==
        CycleStatus.active;
  }

  @override
  Widget build(BuildContext context) {

    if (cycles.isEmpty) {
      return const SizedBox();
    }

    return Column(

      children:

      cycles.map((cycle) {

        return FoodCycleCard(

          // TITLE

          title:

          cycle.title?.trim().isNotEmpty == true

              ? cycle.title!

              : "Food Cycle",

          // COST

          cost:
          calculateCost(cycle),

          // STATUS

          status:
          cycle.status.name
              .toUpperCase(),

          highlight:
          isActive(cycle),

          // DATE

          dateRange:
          formatDateRange(cycle),

          // TIFFIN INFO

          totalTiffin:
          cycle.totalTiffin,

          totalEaten:
          cycle.totalEaten,

          remainingTiffin:
          cycle.remainingTiffin,

          // CLICK

          onTap:
              () => onTap(cycle),
        );
      }).toList(),
    );
  }
}