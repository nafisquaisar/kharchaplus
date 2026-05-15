import 'water_intake_local_ds.dart';
import 'package:isar/isar.dart';

import '../../../../../../../core/services/isar_service.dart';
import '../../../models/water_intake_model.dart';

class WaterIntakeLocalDataSourceImpl implements WaterIntakeLocalDataSource {
  final Isar isar = IsarService.isar;

  @override
  Future<void> addWaterIntake(
    WaterIntakeModel model,
  ) async {
    try {
      await isar.writeTxn(() async {
        await isar.waterIntakeModels.putById(model);
      });
    } on IsarError catch (e) {
      throw WaterIntakeLocalDataSourceException(
        'Failed to add intake "${model.id}".',
        cause: e,
      );
    }
  }

  @override
  Future<void> updateWaterIntake(
    WaterIntakeModel model,
  ) async {
    final existing = await isar.waterIntakeModels.getById(model.id);

    if (existing == null) {
      throw WaterIntakeLocalDataSourceException(
        'Cannot update intake "${model.id}" because it does not exist locally.',
      );
    }

    existing.amountMl = model.amountMl;
    existing.dateTime = model.dateTime;
    existing.sourceType = model.sourceType ?? existing.sourceType;
    existing.userId = model.userId;
    existing.serverId = model.serverId ?? existing.serverId;

    existing.isSynced = false;
    existing.isEdited = true;
    existing.updatedAt = DateTime.now();
    existing.version = model.version <= existing.version
        ? existing.version + 1
        : model.version;

    try {
      await isar.writeTxn(() async {
        await isar.waterIntakeModels.put(existing);
      });
    } on IsarError catch (e) {
      throw WaterIntakeLocalDataSourceException(
        'Failed to update intake "${model.id}".',
        cause: e,
      );
    }
  }

  @override
  Future<void> softDeleteWaterIntake(
    String id,
  ) async {
    final existing = await isar.waterIntakeModels.getById(id);

    if (existing == null) return;

    existing.isDeleted = true;

    existing.isSynced = false;

    existing.updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.waterIntakeModels.put(existing);
    });
  }

  @override
  Future<List<WaterIntakeModel>> getTodayIntake(
    String userId,
  ) async {
    final now = DateTime.now();

    return getIntakeByDate(
      userId,
      DateTime(
        now.year,
        now.month,
        now.day,
      ),
    );
  }

  @override
  Future<List<WaterIntakeModel>> getWeeklyIntake(
    String userId,
  ) async {
    return getIntakeByWeek(
      userId,
      DateTime.now(),
    );
  }

  @override
  Future<List<WaterIntakeModel>> getMonthlyIntake(
    String userId,
  ) async {
    final now = DateTime.now();
    return getIntakeByMonth(
      userId,
      now.year,
      now.month,
    );
  }

  @override
  Future<List<WaterIntakeModel>> getIntakeByDate(
    String userId,
    DateTime date,
  ) async {
    final start = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final end = start.add(
      const Duration(days: 1),
    );

    return isar.waterIntakeModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .isDeletedEqualTo(false)
        .and()
        .dateTimeBetween(
          start,
          end,
        )
        .sortByDateTime()
        .findAll();
  }

  @override
  Future<List<WaterIntakeModel>> getIntakeByWeek(
    String userId,
    DateTime weekAnchor,
  ) async {
    final anchor = DateTime(
      weekAnchor.year,
      weekAnchor.month,
      weekAnchor.day,
    );

    final weekStart = anchor.subtract(
      Duration(days: anchor.weekday - 1),
    );

    final weekEnd = weekStart.add(
      const Duration(days: 7),
    );

    return isar.waterIntakeModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .isDeletedEqualTo(false)
        .and()
        .dateTimeBetween(
          weekStart,
          weekEnd,
        )
        .sortByDateTime()
        .findAll();
  }

  @override
  Future<List<WaterIntakeModel>> getIntakeByMonth(
    String userId,
    int year,
    int month,
  ) async {
    final start = DateTime(
      year,
      month,
      1,
    );

    final end = DateTime(
      year,
      month + 1,
      1,
    );

    return isar.waterIntakeModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .isDeletedEqualTo(false)
        .and()
        .dateTimeBetween(
          start,
          end,
        )
        .sortByDateTime()
        .findAll();
  }

  @override
  Future<List<WaterIntakeModel>> getPendingSync() async {
    return isar.waterIntakeModels.filter().isSyncedEqualTo(false).findAll();
  }

  @override
  Future<WaterIntakeModel?> getById(String id) async {
    return isar.waterIntakeModels.getById(id);
  }

  @override
  Future<void> upsertFromRemote(WaterIntakeModel model) async {
    try {
      await isar.writeTxn(() async {
        await isar.waterIntakeModels.putById(model);
      });
    } on IsarError catch (e) {
      throw WaterIntakeLocalDataSourceException(
        'Failed to upsert remote intake "${model.id}".',
        cause: e,
      );
    }
  }

  @override
  Future<void> markSynced(String id, {String? serverId}) async {
    final existing = await isar.waterIntakeModels.getById(id);

    if (existing == null) return;

    existing.isSynced = true;
    existing.isEdited = false;
    existing.isOfflineCreated = false;
    if (serverId != null) {
      existing.serverId = serverId;
    }

    await isar.writeTxn(() async {
      await isar.waterIntakeModels.put(existing);
    });
  }
}

class WaterIntakeLocalDataSourceException implements Exception {
  final String message;
  final Object? cause;

  const WaterIntakeLocalDataSourceException(
    this.message, {
    this.cause,
  });

  @override
  String toString() {
    if (cause == null) {
      return 'WaterIntakeLocalDataSourceException: $message';
    }
    return 'WaterIntakeLocalDataSourceException: $message Cause: $cause';
  }
}
