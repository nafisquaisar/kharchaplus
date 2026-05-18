import 'package:cloud_firestore/cloud_firestore.dart';


import '../../../domain/entities/FoodCycle.dart';
import '../../../domain/entities/MealEntry.dart';
import '../../../domain/enum/cycle_status.dart';
import '../../../services/FirebaseFoodService.dart';
import '../../../services/food_cycle_status_service.dart';
import 'meal_remote_datasource.dart';

class MealRemoteDataSourceImpl
    implements MealRemoteDataSource {

  final FirebaseFoodService service;

  MealRemoteDataSourceImpl({

    required this.service,
  });

  // =========================
  // CREATE CYCLE
  // =========================

  @override
  Future<void> createCycle(
      FoodCycle cycle,
      ) async {

    await service
        .foodCyclesRef
        .doc(cycle.id)
        .set(
      cycle.toMap(),
    );
  }

  // =========================
  // GET ALL CYCLES
  // =========================

  @override
  Future<List<FoodCycle>>
  getAllCycles() async {

    final snapshot = await service
        .foodCyclesRef
        .where(
      "isDeleted",
      isEqualTo: false,
    )
        .orderBy(
      "createdAt",
      descending: true,
    )
        .get();

    return snapshot.docs.map((doc) {

      return FoodCycle.fromMap(

        doc.data()
        as Map<String, dynamic>,
      );
    }).toList();
  }

  // =========================
  // UPDATE CYCLE
  // =========================

  @override
  Future<void> updateCycle(
      FoodCycle cycle,
      ) async {

    await service
        .foodCyclesRef
        .doc(cycle.id)
        .update(
      cycle.copyWith(
        updatedAt: DateTime.now(),
        version: cycle.version + 1,
      ).toMap(),
    );
  }

  // =========================
  // DELETE CYCLE
  // =========================

  @override
  Future<void> deleteCycle(
      String cycleId,
      ) async {

    await service
        .foodCyclesRef
        .doc(cycleId)
        .update({

      "isDeleted": true,

      "updatedAt": Timestamp.now(),
    });
  }

  // =========================
  // SAVE MEAL ENTRY
  // =========================

  @override
  Future<void> saveMealEntry(
      MealEntry entry,
      ) async {

    await service
        .mealEntriesRef(
      entry.cycleId,
    )
        .doc(entry.id)
        .set(
      entry.toMap(),
      SetOptions(
        merge: true,
      ),
    );

    // AUTO UPDATE CARD STATS

    await updateCycleStats(
      entry.cycleId,
    );
  }

  // =========================
  // DELETE MEAL ENTRY
  // =========================

  @override
  Future<void> deleteMealEntry(
      String cycleId,
      String entryId,
      ) async {

    await service
        .mealEntriesRef(
      cycleId,
    )
        .doc(entryId)
        .set({
      "isDeleted": true,
      "updatedAt": Timestamp.now(),
    }, SetOptions(merge: true));

    await updateCycleStats(
      cycleId,
    );
  }

  // =========================
  // GET MEAL ENTRIES
  // =========================

  @override
  Future<List<MealEntry>>
  getMealEntries(
      String cycleId,
      ) async {

    final snapshot = await service
        .mealEntriesRef(
      cycleId,
    )
        .where(
      "isDeleted",
      isEqualTo: false,
    )
        .orderBy(
      "date",
      descending: false,
    )
        .get();

    return snapshot.docs.map((doc) {

      return MealEntry.fromMap(

        doc.data()
        as Map<String, dynamic>,
      );
    }).toList();
  }


  @override
  Stream<List<MealEntry>>
  watchMealEntries(
      String cycleId,
      ) {

    return service
        .mealEntriesRef(
      cycleId,
    )
        .where(
      "isDeleted",
      isEqualTo: false,
    )
        .orderBy(
      "date",
      descending: false,
    )
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {

        return MealEntry.fromMap(

          doc.data()
          as Map<String, dynamic>,
        );

      }).toList();
    });
  }


  // =========================
// UPDATE FOOD CYCLE STATS
// =========================

  Future<void> updateCycleStats(
      String cycleId,
      ) async {

    final mealSnapshot = await service
        .mealEntriesRef(cycleId)
        .where(
      "isDeleted",
      isEqualTo: false,
    )
        .get();

    int totalEaten = 0;

    for (final doc in mealSnapshot.docs) {

      final meal = MealEntry.fromMap(
        doc.data() as Map<String, dynamic>,
      );

      if (meal.lunch) {
        totalEaten++;
      }

      if (meal.dinner) {
        totalEaten++;
      }
    }

    // =========================
    // GET CYCLE
    // =========================

    final cycleDoc = await service
        .foodCyclesRef
        .doc(cycleId)
        .get();

    if (!cycleDoc.exists) {
      return;
    }

    final cycle = FoodCycle.fromMap(
      cycleDoc.data() as Map<String, dynamic>,
    );

    final remaining =
        cycle.totalTiffin - totalEaten;

    // =========================
    // STATUS
    // =========================

    final status =
    remaining <= 0
        ? CycleStatus.completed
        : FoodCycleStatusService
        .getStatus(
      cycle.copyWith(
        totalEaten: totalEaten,
      ),
    );

    // =========================
    // UPDATE FIRESTORE
    // =========================

    await service
        .foodCyclesRef
        .doc(cycleId)
        .update({

      "totalEaten": totalEaten,

      "remainingTiffin":
      remaining < 0
          ? 0
          : remaining,

      "status": status.name,

      "updatedAt":
      Timestamp.now(),
    });
  }


}