import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../../models/food_tracking_model.dart';

abstract class FoodTrackingHomeLocalDataSource {
  Future<List<FoodTrackingHomeModel>> getFoodCycles();

  Stream<List<FoodTrackingHomeModel>> watchFoodCycles();

  Future<void> upsertFoodCycles(List<FoodTrackingHomeModel> cycles);
}

class FoodTrackingHomeLocalDataSourceImpl
    implements FoodTrackingHomeLocalDataSource {
  final Isar isar;

  FoodTrackingHomeLocalDataSourceImpl(this.isar);

  @override
  Future<List<FoodTrackingHomeModel>> getFoodCycles() async {
    try {
      final result = await isar.foodTrackingHomeModels
          .where()
          .sortByUpdatedAtDesc()
          .findAll();
      debugPrint('[FoodHomeLocal] fetched ${result.length} items');
      return result;
    } catch (e, stack) {
      debugPrint('[FoodHomeLocal] fetch failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Stream<List<FoodTrackingHomeModel>> watchFoodCycles() {
    return isar.foodTrackingHomeModels
        .where()
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }

  @override
  Future<void> upsertFoodCycles(List<FoodTrackingHomeModel> cycles) async {
    if (cycles.isEmpty) {
      return;
    }

    try {
      final existing = await isar.foodTrackingHomeModels.where().findAll();
      final existingMap = {
        for (final item in existing) item.id: item.isarId,
      };

      for (final cycle in cycles) {
        final existingId = existingMap[cycle.id];
        if (existingId != null) {
          cycle.isarId = existingId;
        }
      }

      await isar.writeTxn(() async {
        await isar.foodTrackingHomeModels.putAll(cycles);
      });

      debugPrint('[FoodHomeLocal] upserted ${cycles.length} items');
    } catch (e, stack) {
      debugPrint('[FoodHomeLocal] upsert failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }
}

