import '../entities/RecentActivityEntity.dart';

abstract class RecentActivityRepository {

  Future<void> addActivity(
      RecentActivityEntity activity,
      );

  Future<List<RecentActivityEntity>>
  getRecentActivities(
      String userId,
      );

  Stream<List<RecentActivityEntity>>
  watchRecentActivities(
      String userId,
      );

  Stream<List<RecentActivityEntity>>
  watchRemoteActivities(
      String userId,
      );

  Future<void> syncRecentActivities(
      String userId,
      );

  Future<void> updateActivity(
      RecentActivityEntity activity,
      );

  Future<void> deleteActivity(
      String referenceId,
      String userId,
      );

  Future<void> deleteActivityById(
      String id,
      );
}