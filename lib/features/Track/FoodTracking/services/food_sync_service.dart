import 'package:flutter/foundation.dart';

import '../../data/datasource/remote/tracking_updater.dart';
import '../domain/entities/FoodCycle.dart';
import '../domain/entities/MealEntry.dart';
import '../domain/enum/cycle_status.dart';
import 'FirebaseFoodService.dart';

class FoodSyncService {
  final FirebaseFoodService service;
  final TrackingUpdater trackingUpdater;

  FoodSyncService({
    required this.service,
    TrackingUpdater? trackingUpdater,
  }) : trackingUpdater = trackingUpdater ??
            TrackingUpdater(
              firestore: service.firestore,
              auth: service.auth,
            );

  Future<void> syncTrackingModule() async {
    final cyclesSnapshot = await service.foodCyclesRef
        .where(
          'isDeleted',
          isEqualTo: false,
        )
        .get();

    double totalAmount = 0;
    double todayAmount = 0;
    double monthlyAmount = 0;
    int totalRecords = 0;
    int activeCycles = 0;

    final now = DateTime.now();

    for (final cycleDoc in cyclesSnapshot.docs) {
      final cycle = FoodCycle.fromMap(cycleDoc.data() as Map<String, dynamic>);

      if (cycle.status == CycleStatus.active ||
          cycle.status == CycleStatus.upcoming) {
        activeCycles++;
      }

      final mealsSnapshot = await service
          .mealEntriesRef(cycle.id)
          .where(
            'isDeleted',
            isEqualTo: false,
          )
          .get();

      totalRecords += mealsSnapshot.docs.length;

      for (final mealDoc in mealsSnapshot.docs) {
        final meal = MealEntry.fromMap(mealDoc.data() as Map<String, dynamic>);
        final mealCost = _countPricedMeals(meal) * cycle.mealPrice;

        totalAmount += mealCost;

        if (_isSameDay(meal.date, now)) {
          todayAmount += mealCost;
        }

        if (meal.date.year == now.year && meal.date.month == now.month) {
          monthlyAmount += mealCost;
        }
      }
    }

    await trackingUpdater.ensureTrackingModules();
    await trackingUpdater.upsertTrackingSnapshot(
      type: 'food',
      totalAmount: totalAmount,
      todayAmount: todayAmount,
      monthlyAmount: monthlyAmount,
      activeCycles: activeCycles,
      totalRecords: totalRecords,
    );

    debugPrint(
      '[FoodTrackingSync] total=$totalAmount today=$todayAmount monthly=$monthlyAmount active=$activeCycles records=$totalRecords',
    );
  }

  int _countPricedMeals(MealEntry meal) {
    var count = 0;
    if (meal.lunch) {
      count++;
    }
    if (meal.dinner) {
      count++;
    }
    return count;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
