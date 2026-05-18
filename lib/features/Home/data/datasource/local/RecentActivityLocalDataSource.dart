import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';

import '../../models/recent_activity_model.dart';

abstract class RecentActivityLocalDataSource {
  Future<void> addActivity(
    RecentActivityModel activity,
  );

  Future<List<RecentActivityModel>> getRecentActivities();

  Stream<List<RecentActivityModel>> watchRecentActivities();

  Future<void> upsertActivities(
    List<RecentActivityModel> activities,
  );

  Future<void> updateActivity(
    RecentActivityModel activity,
  );

  Future<void> deleteActivity(
    String referenceId,
  );

  Future<void> deleteActivityById(
    String id,
  );

  Future<RecentActivityModel?> getByReferenceId(
    String referenceId,
  );
}

class RecentActivityLocalDataSourceImpl implements RecentActivityLocalDataSource {
  final Isar isar;

  RecentActivityLocalDataSourceImpl(this.isar);

  @override
  Future<void> addActivity(
    RecentActivityModel activity,
  ) async {
    try {
      await isar.writeTxn(() async {
        await isar.recentActivityModels.put(activity);
      });
      debugPrint('RecentActivityLocalDataSource: added ${activity.id}');
    } catch (e, stack) {
      debugPrint('RecentActivityLocalDataSource: add failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Future<List<RecentActivityModel>> getRecentActivities() async {
    try {
      final result = await isar.recentActivityModels
          .where()
          .sortByCreatedAtDesc()
          .findAll();
      debugPrint('RecentActivityLocalDataSource: fetched ${result.length} items');
      return result;
    } catch (e, stack) {
      debugPrint('RecentActivityLocalDataSource: fetch failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Stream<List<RecentActivityModel>> watchRecentActivities() {
    return isar.recentActivityModels
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  @override
  Future<void> upsertActivities(
    List<RecentActivityModel> activities,
  ) async {
    if (activities.isEmpty) {
      return;
    }

    try {
      final existing = await isar.recentActivityModels
          .where()
          .findAll();

      final existingMap = {
        for (final item in existing)
          item.referenceId: item.isarId,
      };

      for (final activity in activities) {
        final existingId = existingMap[activity.referenceId];
        if (existingId != null) {
          activity.isarId = existingId;
        }
      }

      await isar.writeTxn(() async {
        await isar.recentActivityModels.putAll(activities);
      });
      debugPrint('RecentActivityLocalDataSource: upserted ${activities.length} items');
    } catch (e, stack) {
      debugPrint('RecentActivityLocalDataSource: upsert failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Future<void> updateActivity(
    RecentActivityModel activity,
  ) async {
    try {
      final matches = await isar.recentActivityModels
          .filter()
          .referenceIdEqualTo(activity.referenceId)
          .findAll();

      RecentActivityModel? keep;
      if (matches.isNotEmpty) {
        keep = matches.reduce(
          (a, b) => a.createdAt.isAfter(b.createdAt) ? a : b,
        );
        activity.isarId = keep.isarId;
      }

      await isar.writeTxn(() async {
        await isar.recentActivityModels.put(activity);

        if (matches.length > 1) {
          final duplicateIds = matches
              .where((item) => item.isarId != activity.isarId)
              .map((item) => item.isarId)
              .toList();
          await isar.recentActivityModels.deleteAll(duplicateIds);
          debugPrint(
            'RecentActivityLocalDataSource: deduped referenceId=${activity.referenceId} removed=${duplicateIds.length}',
          );
        }
      });
      debugPrint('RecentActivityLocalDataSource: updated ${activity.id}');
    } catch (e, stack) {
      debugPrint('RecentActivityLocalDataSource: update failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Future<void> deleteActivity(
    String referenceId,
  ) async {
    try {
      final activity = await isar.recentActivityModels
          .filter()
          .referenceIdEqualTo(referenceId)
          .findFirst();

      if (activity != null) {
        await isar.writeTxn(() async {
          await isar.recentActivityModels.delete(activity.isarId);
        });
        debugPrint('RecentActivityLocalDataSource: deleted $referenceId');
        return;
      }

      debugPrint('RecentActivityLocalDataSource: delete skipped, not found $referenceId');
    } catch (e, stack) {
      debugPrint('RecentActivityLocalDataSource: delete failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Future<void> deleteActivityById(
    String id,
  ) async {
    try {
      final activity = await isar.recentActivityModels
          .filter()
          .idEqualTo(id)
          .findFirst();

      if (activity != null) {
        await isar.writeTxn(() async {
          await isar.recentActivityModels.delete(activity.isarId);
        });
        debugPrint('RecentActivityLocalDataSource: deleted id $id');
      }
    } catch (e, stack) {
      debugPrint('RecentActivityLocalDataSource: delete by id failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Future<RecentActivityModel?> getByReferenceId(
    String referenceId,
  ) async {
    try {
      return await isar.recentActivityModels
          .filter()
          .referenceIdEqualTo(referenceId)
          .findFirst();
    } catch (e, stack) {
      debugPrint('RecentActivityLocalDataSource: getByReferenceId failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }
}
