import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../../models/water_tracking_model.dart';

abstract class WaterTrackingHomeLocalDataSource {
  Future<WaterTrackingHomeModel?> getSnapshot(String userId);

  Stream<WaterTrackingHomeModel?> watchSnapshot(String userId);

  Future<void> upsertSnapshot(WaterTrackingHomeModel snapshot);
}

class WaterTrackingHomeLocalDataSourceImpl
    implements WaterTrackingHomeLocalDataSource {
  final Isar isar;

  WaterTrackingHomeLocalDataSourceImpl(this.isar);

  @override
  Future<WaterTrackingHomeModel?> getSnapshot(String userId) async {
    try {
      final result = await isar.waterTrackingHomeModels
          .filter()
          .idEqualTo(userId)
          .findFirst();
      debugPrint('[WaterHomeLocal] fetched snapshot user=$userId exists=${result != null}');
      return result;
    } catch (e, stack) {
      debugPrint('[WaterHomeLocal] fetch failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Stream<WaterTrackingHomeModel?> watchSnapshot(String userId) {
    return isar.waterTrackingHomeModels
        .filter()
        .idEqualTo(userId)
        .watch(fireImmediately: true)
        .map((items) => items.isEmpty ? null : items.first);
  }

  @override
  Future<void> upsertSnapshot(WaterTrackingHomeModel snapshot) async {
    try {
      final existing = await isar.waterTrackingHomeModels
          .filter()
          .idEqualTo(snapshot.id)
          .findFirst();
      if (existing != null) {
        snapshot.isarId = existing.isarId;
      }

      await isar.writeTxn(() async {
        await isar.waterTrackingHomeModels.put(snapshot);
      });

      debugPrint('[WaterHomeLocal] upserted snapshot user=${snapshot.id}');
    } catch (e, stack) {
      debugPrint('[WaterHomeLocal] upsert failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }
}

