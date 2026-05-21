import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/RecentActivityEntity.dart';
import '../../domain/repository/RecentActivityRepository.dart';
import '../datasource/local/RecentActivityLocalDataSource.dart';
import '../datasource/remote/recent_activity_remote_datasource.dart';
import '../models/recent_activity_model.dart';
import 'package:flutter/foundation.dart';

class RecentActivityRepositoryImpl implements RecentActivityRepository {
  final RecentActivityLocalDataSource localDataSource;
  final RecentActivityRemoteDataSource remoteDataSource;
  final String userId =
      FirebaseAuth.instance.currentUser!.uid;

  RecentActivityRepositoryImpl(
    this.localDataSource,
    this.remoteDataSource,
  );

  @override
  Future<void> addActivity(
    RecentActivityEntity activity,
  ) async {
    final existing = await localDataSource.getByReferenceId(
      activity.referenceId,activity.userId
    );

    if (existing != null) {
      debugPrint(
        'RecentActivityRepository: add converted to update referenceId=${activity.referenceId} existingId=${existing.id}',
      );
      await updateActivity(activity);
      return;
    }

    final model = RecentActivityModel.fromEntity(
      activity,
    );

    try {
      await localDataSource.addActivity(
        model,
      );
    } catch (e) {
      debugPrint('RecentActivityRepository: local add failed $e');
      rethrow;
    }

    try {
      await remoteDataSource.addActivity(model);
    } catch (e) {
      debugPrint('RecentActivityRepository: remote add failed $e');
    }
  }

  @override
  Future<List<RecentActivityEntity>> getRecentActivities() async {
    try {
      final local = await localDataSource.getRecentActivities(userId);

      _syncFromRemoteInBackground();

      return local;
    } catch (e) {
      debugPrint('RecentActivityRepository: get failed $e');
      rethrow;
    }
  }

  @override
  Stream<List<RecentActivityEntity>> watchRecentActivities() {
    return localDataSource.watchRecentActivities(userId);
  }

  @override
  Stream<List<RecentActivityEntity>> watchRemoteActivities() async* {
    await for (final remote in remoteDataSource.watchRecentActivities()) {
      try {
        await localDataSource.upsertActivities(remote);
      } catch (e) {
        debugPrint('RecentActivityRepository: remote cache failed $e');
      }
      yield remote;
    }
  }

  @override
  Future<void> syncRecentActivities() async {
    try {
      final remote = await remoteDataSource.getRecentActivities();
      await localDataSource.upsertActivities(remote);
      debugPrint('RecentActivityRepository: sync completed');
    } catch (e) {
      debugPrint('RecentActivityRepository: sync failed $e');
      rethrow;
    }
  }

  void _syncFromRemoteInBackground() {
    syncRecentActivities().catchError((e, stack) {
      debugPrint('RecentActivityRepository: background sync failed $e');
      debugPrint('$stack');
    });
  }

  @override
  Future<void> updateActivity(
    RecentActivityEntity activity,
  ) async {

    final existing = await localDataSource.getByReferenceId(
      activity.referenceId,activity.userId
    );

    final model = RecentActivityModel.fromEntity(
      existing != null
          ? RecentActivityEntity(
              id: existing.id,
              userId: existing.userId,
              type: activity.type,
              title: activity.title,
              subtitle: activity.subtitle,
              amount: activity.amount,
              createdAt: existing.createdAt,
              updatedAt: DateTime.now(),
              referenceId: activity.referenceId,
              isSynced: false,
              isDeleted: false,
              isEdited: true,
              version: existing.version + 1,
            )
          : activity,
    );

    debugPrint(
      'RecentActivityRepository: update referenceId=${activity.referenceId} existing=${existing != null} activityId=${activity.id} storedId=${model.id}',
    );

    try {
      await localDataSource.updateActivity(model);
    } catch (e) {
      debugPrint('RecentActivityRepository: local update failed $e');
      rethrow;
    }

    try {
      await remoteDataSource.updateActivity(model);
    } catch (e) {
      debugPrint('RecentActivityRepository: remote update failed $e');
    }
  }

  @override
  Future<void> deleteActivity(
    String referenceId,
  ) async {
    try {
      await localDataSource.deleteActivity(
        referenceId,userId
      );
    } catch (e) {
      debugPrint('RecentActivityRepository: local delete failed $e');
      rethrow;
    }

    try {
      await remoteDataSource.deleteActivity(referenceId);
    } catch (e) {
      debugPrint('RecentActivityRepository: remote delete failed $e');
    }
  }

  Future<void> deleteActivityById(
    String id,
  ) async {
    try {
      await localDataSource.deleteActivityById(id,userId);
    } catch (e) {
      debugPrint('RecentActivityRepository: local delete by id failed $e');
      rethrow;
    }

    try {
      await remoteDataSource.deleteActivityById(id);
    } catch (e) {
      debugPrint('RecentActivityRepository: remote delete by id failed $e');
    }
  }
}
