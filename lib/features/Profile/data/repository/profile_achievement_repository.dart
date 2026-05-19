import '../models/profile_achievement_model.dart';

abstract class ProfileAchievementRepository {
  Stream<List<ProfileAchievementModel>> watchAchievements(String uid);

  Future<List<ProfileAchievementModel>> getAchievements(String uid);

  Future<void> evaluateAndSync(String uid, {DateTime? now});

  Future<void> syncPending(String uid);

  Future<void> refreshFromRemote(String uid);
}

