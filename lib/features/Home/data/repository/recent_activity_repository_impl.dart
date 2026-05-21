import 'package:flutter/foundation.dart';

import '../../domain/entities/RecentActivityEntity.dart';
import '../../domain/repository/RecentActivityRepository.dart';

import '../datasource/local/RecentActivityLocalDataSource.dart';
import '../datasource/remote/recent_activity_remote_datasource.dart';

import '../models/recent_activity_model.dart';

class RecentActivityRepositoryImpl implements RecentActivityRepository {
  final RecentActivityLocalDataSource localDataSource;

  final RecentActivityRemoteDataSource remoteDataSource;

  RecentActivityRepositoryImpl(
    this.localDataSource,
    this.remoteDataSource,
  );

  // =====================================================
  // ADD ACTIVITY
  // =====================================================

  @override
  Future<void> addActivity(
    RecentActivityEntity activity,
  ) async {
    try {
      final existing = await localDataSource.getByReferenceId(
        activity.referenceId,
      );

      // already exists -> update
      if (existing != null) {
        debugPrint(
          'RecentActivityRepository: already exists -> updating',
        );

        await updateActivity(activity);

        return;
      }

      final model = RecentActivityModel.fromEntity(
        activity,
      );

      // LOCAL SAVE
      await localDataSource.addActivity(
        model,
      );

      // REMOTE SAVE
      try {
        await remoteDataSource.addActivity(
          model.copyWith(
            isSynced: true,
          ),
        );

        // update local sync status
        await localDataSource.updateActivity(
          model.copyWith(
            isSynced: true,
          ),
        );
      } catch (e) {
        debugPrint(
          'RecentActivityRepository: remote add failed $e',
        );
      }
    } catch (e, stack) {
      debugPrint(
        'RecentActivityRepository: add failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // GET RECENT ACTIVITIES
  // =====================================================

  @override
  Future<List<RecentActivityEntity>> getRecentActivities(
    String userId,
  ) async {
    try {
      final local = await localDataSource.getRecentActivities(
        userId,
      );

      _syncFromRemoteInBackground(
        userId,
      );

      return local
          .where(
            (e) => !e.isDeleted,
          )
          .toList();
    } catch (e, stack) {
      debugPrint(
        'RecentActivityRepository: get failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // WATCH LOCAL
  // =====================================================

  @override
  Stream<List<RecentActivityEntity>> watchRecentActivities(
    String userId,
  ) {
    return localDataSource.watchRecentActivities(userId).map(
          (items) => items
              .where(
                (e) => !e.isDeleted,
              )
              .toList(),
        );
  }

  // =====================================================
  // WATCH REMOTE
  // =====================================================

  @override
  Stream<List<RecentActivityEntity>> watchRemoteActivities(
    String userId,
  ) async* {
    await for (final remote in remoteDataSource.watchRecentActivities(userId)) {
      try {
        await localDataSource.upsertActivities(
          remote,
        );
      } catch (e) {
        debugPrint(
          'RecentActivityRepository: remote cache failed $e',
        );
      }

      yield remote
          .where(
            (e) => !e.isDeleted,
          )
          .toList();
    }
  }

  // =====================================================
  // SYNC
  // =====================================================

  @override
  Future<void> syncRecentActivities(
    String userId,
  ) async {
    try {
      final remote = await remoteDataSource.getRecentActivities(
        userId,
      );

      await localDataSource.upsertActivities(
        remote,
      );

      debugPrint(
        'RecentActivityRepository: sync completed',
      );
    } catch (e, stack) {
      debugPrint(
        'RecentActivityRepository: sync failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  void _syncFromRemoteInBackground(
    String userId,
  ) {
    syncRecentActivities(
      userId,
    ).catchError(
      (e, stack) {
        debugPrint(
          'RecentActivityRepository: background sync failed $e',
        );

        debugPrint('$stack');
      },
    );
  }

  // =====================================================
  // UPDATE
  // =====================================================

  @override
  Future<void> updateActivity(RecentActivityEntity activity,) async {
    try {
      final existing = await localDataSource.getByReferenceId(
        activity.referenceId,
      );

      final updatedModel = RecentActivityModel.fromEntity(
        existing != null
            ? existing.copyWith(
                type: activity.type,
                title: activity.title,
                subtitle: activity.subtitle,
                amount: activity.amount,
                updatedAt: DateTime.now(),
                isEdited: true,
                version: existing.version + 1,
                isSynced: false,
              )
            : activity,
      );

      // LOCAL UPDATE
      await localDataSource.updateActivity(
        updatedModel,
      );

      // REMOTE UPDATE
      try {
        await remoteDataSource.updateActivity(
          updatedModel.copyWith(
            isSynced: true,
          ),
        );

        // mark synced locally
        await localDataSource.updateActivity(
          updatedModel.copyWith(
            isSynced: true,
          ),
        );
      } catch (e) {
        debugPrint(
          'RecentActivityRepository: remote update failed $e',
        );
      }
    } catch (e, stack) {
      debugPrint(
        'RecentActivityRepository: update failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // DELETE
  // =====================================================

  @override
  Future<void> deleteActivity(
      String referenceId,
      String userId,
      ) async {
    try {
      final existing = await localDataSource.getByReferenceId(
        referenceId,
      );

      if (existing == null) {
        return;
      }

      // SOFT DELETE
      final deletedModel = existing.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
        isSynced: false,
        version: existing.version + 1,
      );

      // LOCAL
      await localDataSource.updateActivity(
        deletedModel,
      );

      // REMOTE
      try {
        await remoteDataSource.updateActivity(
          deletedModel.copyWith(
            isSynced: true,
          ),
        );

        await localDataSource.updateActivity(
          deletedModel.copyWith(
            isSynced: true,
          ),
        );
      } catch (e) {
        debugPrint(
          'RecentActivityRepository: remote delete failed $e',
        );
      }
    } catch (e, stack) {
      debugPrint(
        'RecentActivityRepository: delete failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // HARD DELETE
  // =====================================================

  @override
  Future<void> deleteActivityById(
    String id,
  ) async {
    try {
      await localDataSource.deleteActivityById(id);

      try {
        await remoteDataSource.deleteActivityById(id);
      } catch (e) {
        debugPrint(
          'RecentActivityRepository: remote hard delete failed $e',
        );
      }
    } catch (e, stack) {
      debugPrint(
        'RecentActivityRepository: hard delete failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }
}
