import 'package:isar/isar.dart';

part 'profile_achievement_model.g.dart';

@collection
class ProfileAchievementModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String key;

  @Index()
  late String userId;

  @Index()
  late String achievementId;

  late String category;

  late String title;

  late String description;

  late String iconKey;

  late double progress;

  late double goal;

  late bool isUnlocked;

  DateTime? unlockedAt;

  late DateTime updatedAt;

  late bool isSynced;

  DateTime? lastSyncedAt;
}

