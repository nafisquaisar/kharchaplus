import '../domain/entities/FoodCycle.dart';

import '../domain/enum/cycle_status.dart';

class FoodCycleStatusService {

  static CycleStatus getStatus(
      FoodCycle cycle,
      ) {

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final start = DateTime(
      cycle.startDate.year,
      cycle.startDate.month,
      cycle.startDate.day,
    );

    final end = DateTime(
      cycle.endDate.year,
      cycle.endDate.month,
      cycle.endDate.day,
    );

    // =========================
    // UPCOMING
    // =========================

    if (today.isBefore(start)) {

      return CycleStatus.upcoming;
    }

    // =========================
    // COMPLETED
    // END DATE OR TIFFIN FINISHED
    // =========================

    final tiffinCompleted =

        cycle.totalEaten >=
            cycle.totalTiffin;

    final dateCompleted =

    today.isAfter(end);

    if (tiffinCompleted ||
        dateCompleted) {

      return CycleStatus.completed;
    }

    // =========================
    // ACTIVE
    // =========================

    return CycleStatus.active;
  }
}