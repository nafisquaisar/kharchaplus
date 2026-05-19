import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../../models/electricity_tracking_model.dart';

abstract class ElectricityTrackingHomeLocalDataSource {
  Future<List<ElectricityTrackingHomeModel>> getElectricityCycles();

  Stream<List<ElectricityTrackingHomeModel>> watchElectricityCycles();

  Future<void> upsertElectricityCycles(List<ElectricityTrackingHomeModel> cycles);
}

class ElectricityTrackingHomeLocalDataSourceImpl
    implements ElectricityTrackingHomeLocalDataSource {
  final Isar isar;

  ElectricityTrackingHomeLocalDataSourceImpl(this.isar);

  @override
  Future<List<ElectricityTrackingHomeModel>> getElectricityCycles() async {
    try {
      final result = await isar.electricityTrackingHomeModels
          .where()
          .sortByUpdatedAtDesc()
          .findAll();
      debugPrint('[ElectricityHomeLocal] fetched ${result.length} items');
      return result;
    } catch (e, stack) {
      debugPrint('[ElectricityHomeLocal] fetch failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Stream<List<ElectricityTrackingHomeModel>> watchElectricityCycles() {
    return isar.electricityTrackingHomeModels
        .where()
        .sortByUpdatedAtDesc()
        .watch(fireImmediately: true);
  }

  @override
  Future<void> upsertElectricityCycles(
    List<ElectricityTrackingHomeModel> cycles,
  ) async {
    if (cycles.isEmpty) {
      return;
    }

    try {
      final existing = await isar.electricityTrackingHomeModels.where().findAll();
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
        await isar.electricityTrackingHomeModels.putAll(cycles);
      });

      debugPrint('[ElectricityHomeLocal] upserted ${cycles.length} items');
    } catch (e, stack) {
      debugPrint('[ElectricityHomeLocal] upsert failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }
}

