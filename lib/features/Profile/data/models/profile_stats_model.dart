import 'package:isar/isar.dart';

part 'profile_stats_model.g.dart';

@collection
class ProfileStatsModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String userId;

  late int currentStreak;

  late int lastOpenedDayKey;

  late DateTime lastOpenedAt;

  late int timezoneOffsetMinutes;

  late int monthlyGoalDaysCompleted;

  late int monthlyGoalDaysInMonth;

  late double monthlyGoalPercent;

  late bool isSynced;

  DateTime? lastSyncedAt;

  late DateTime updatedAt;
}
