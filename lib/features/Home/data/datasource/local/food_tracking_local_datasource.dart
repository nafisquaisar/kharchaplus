import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      final currentUser = FirebaseAuth.instance.currentUser?.uid ?? '';

      final result = await isar.foodTrackingHomeModels
          .where()
          .sortByUpdatedAtDesc()
          .findAll();

      // Filter locally by current user and non-deleted flag
      final filtered = result.where((m) => m.userId == currentUser && !m.isDeleted).toList();
      debugPrint('[FoodHomeLocal] fetched ${filtered.length} items for user=$currentUser');
      return filtered;
    } catch (e, stack) {
      debugPrint('[FoodHomeLocal] fetch failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Stream<List<FoodTrackingHomeModel>> watchFoodCycles() {
    // We watch all local items but filter stream events to the current user
    return isar.foodTrackingHomeModels
        .where()
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true)
        .map((list) {
      final currentUser = FirebaseAuth.instance.currentUser?.uid ?? '';
      return list.where((m) => m.userId == currentUser && !m.isDeleted).toList();
    });
  }

  @override
  Future<void> upsertFoodCycles(List<FoodTrackingHomeModel> cycles) async {
    if (cycles.isEmpty) {
      return;
    }

    try {
      final currentUser = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Ensure incoming cycles are tagged with the current user
      for (final cycle in cycles) {
        if (cycle.userId.isEmpty) {
          cycle.userId = currentUser;
        }
      }

      // Load existing local entries for this user
      final existing = await isar.foodTrackingHomeModels.where().findAll();
      final existingForUser = existing.where((e) => e.userId == currentUser).toList();
      final existingMap = {for (final item in existingForUser) item.id: item.isarId};

      for (final cycle in cycles) {
        final existingId = existingMap[cycle.id];
        if (existingId != null) {
          cycle.isarId = existingId;
        }
      }

      int deletedCount = 0;

      await isar.writeTxn(() async {
        await isar.foodTrackingHomeModels.putAll(cycles);

        // Reconciliation: delete local records for this user that are not present remotely
        final remoteActiveIds = cycles.where((c) => !c.isDeleted).map((c) => c.id).toSet();
        final localIds = existingForUser.map((e) => e.id).toSet();
        final idsToDelete = localIds.difference(remoteActiveIds);

        if (idsToDelete.isNotEmpty) {
          // convert idsToDelete -> isarIds
          final toDeleteIsarIds = existingForUser
              .where((e) => idsToDelete.contains(e.id))
              .map((e) => e.isarId)
              .toList();

          for (final isarId in toDeleteIsarIds) {
            await isar.foodTrackingHomeModels.delete(isarId);
          }
          deletedCount = toDeleteIsarIds.length;
        }
      });

      debugPrint('[FoodHomeLocal] upserted ${cycles.length} items for user=$currentUser; deleted=$deletedCount');
    } catch (e, stack) {
      debugPrint('[FoodHomeLocal] upsert failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }
}

