import '../entities/RecentActivityEntity.dart';

abstract class RecentActivityRepository {
  Future<void> addActivity(
      RecentActivityEntity activity,
      );

  Future<List<RecentActivityEntity>>
  getRecentActivities();

  Stream<List<RecentActivityEntity>> watchRecentActivities();

  Stream<List<RecentActivityEntity>> watchRemoteActivities();

  Future<void> syncRecentActivities();

  Future<void> updateActivity(
      RecentActivityEntity activity,
      );

  Future<void> deleteActivity(
      String referenceId,
      );
}