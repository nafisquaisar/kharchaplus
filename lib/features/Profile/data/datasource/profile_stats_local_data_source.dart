import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../models/profile_stats_model.dart';

abstract class ProfileStatsLocalDataSource {
  Future<ProfileStatsModel?> getByUserId(String uid);

  Stream<ProfileStatsModel?> watchByUserId(String uid);

  Future<void> upsert(ProfileStatsModel model);
}

class ProfileStatsLocalDataSourceImpl
    implements ProfileStatsLocalDataSource {
  final Isar isar;

  ProfileStatsLocalDataSourceImpl(this.isar);

  @override
  Future<ProfileStatsModel?> getByUserId(String uid) async {
    try {
      return await isar.profileStatsModels
          .filter()
          .userIdEqualTo(uid)
          .findFirst();
    } catch (e, stack) {
      debugPrint('ProfileStatsLocalDataSource: get failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Stream<ProfileStatsModel?> watchByUserId(String uid) {
    return isar.profileStatsModels
        .filter()
        .userIdEqualTo(uid)
        .watch(fireImmediately: true)
        .map((items) => items.isNotEmpty ? items.first : null);
  }

  @override
  Future<void> upsert(ProfileStatsModel model) async {
    try {
      final existing = await getByUserId(model.userId);
      if (existing != null) {
        model.isarId = existing.isarId;
      }

      await isar.writeTxn(() async {
        await isar.profileStatsModels.put(model);
      });
      debugPrint('ProfileStatsLocalDataSource: upserted ${model.userId}');
    } catch (e, stack) {
      debugPrint('ProfileStatsLocalDataSource: upsert failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }
}

