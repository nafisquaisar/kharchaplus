import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../models/profile_achievement_model.dart';

abstract class ProfileAchievementLocalDataSource {
  Stream<List<ProfileAchievementModel>> watchAll(String uid);

  Future<List<ProfileAchievementModel>> getAll(String uid);

  Future<void> upsertAll(List<ProfileAchievementModel> items);
}

class ProfileAchievementLocalDataSourceImpl
    implements ProfileAchievementLocalDataSource {
  final Isar isar;

  ProfileAchievementLocalDataSourceImpl(this.isar);

  @override
  Stream<List<ProfileAchievementModel>> watchAll(String uid) {
    return isar.profileAchievementModels
        .filter()
        .userIdEqualTo(uid)
        .watch(fireImmediately: true);
  }

  @override
  Future<List<ProfileAchievementModel>> getAll(String uid) async {
    try {
      return await isar.profileAchievementModels
          .filter()
          .userIdEqualTo(uid)
          .findAll();
    } catch (e, stack) {
      debugPrint('ProfileAchievementLocalDataSource: fetch failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Future<void> upsertAll(List<ProfileAchievementModel> items) async {
    if (items.isEmpty) {
      return;
    }

    try {
      await isar.writeTxn(() async {
        await isar.profileAchievementModels.putAll(items);
      });
      debugPrint(
        'ProfileAchievementLocalDataSource: upserted ${items.length} items',
      );
    } catch (e, stack) {
      debugPrint('ProfileAchievementLocalDataSource: upsert failed $e');
      debugPrint('$stack');
      rethrow;
    }
  }
}

