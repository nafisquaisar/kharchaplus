import '../models/profile_stats_model.dart';

abstract class ProfileStatsRepository {
  Stream<ProfileStatsModel?> watchStats(String uid);

  Future<ProfileStatsModel> recordAppOpen(String uid, {DateTime? now});

  Future<void> recomputeMonthlyGoal(String uid, {DateTime? now});

  Stream<void> watchMonthlyGoalChanges(String uid);

  Future<void> syncPending(String uid);
}
