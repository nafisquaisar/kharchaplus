import 'package:flutter/foundation.dart';

import '../../../../core/services/auth_service.dart';
import '../../domain/entities/water_tracking_entity.dart';
import '../../domain/repository/water_tracking_home_repository.dart';
import '../mapper/water_tracking_mapper.dart';
import '../../services/water_tracking_home_cache_service.dart';
import '../../services/water_tracking_home_sync_service.dart';

class WaterTrackingHomeRepositoryImpl implements WaterTrackingHomeRepository {
  final WaterTrackingHomeCacheService cacheService;
  final WaterTrackingHomeSyncService syncService;
  final AuthService authService;

  WaterTrackingHomeRepositoryImpl({
    required this.cacheService,
    required this.syncService,
    required this.authService,
  });

  @override
  Future<WaterTrackingHomeEntity?> getCachedSnapshot() async {
    try {
      final userId = await authService.getCurrentUserId();
      final local = await cacheService.getCachedSnapshot(userId);
      _syncInBackground();
      final entity = local == null ? null : WaterTrackingHomeMapper.toEntity(local);
      debugPrint('[WaterHomeRepo] cached snapshot user=$userId exists=${entity != null}');
      return entity;
    } catch (e) {
      debugPrint('[WaterHomeRepo] get cached failed $e');
      rethrow;
    }
  }

  @override
  Stream<WaterTrackingHomeEntity?> watchCachedSnapshot() async* {
    final userId = await authService.getCurrentUserId();
    yield* cacheService.watchCachedSnapshot(userId).map(
          (item) => item == null ? null : WaterTrackingHomeMapper.toEntity(item),
        );
  }

  @override
  Stream<WaterTrackingHomeEntity?> watchRemoteSnapshot() async* {
    await for (final remote in syncService.watchRemoteSnapshot()) {
      if (remote != null) {
        try {
          await cacheService.upsertCachedSnapshot(remote);
          debugPrint('[WaterHomeRepo] remote cache updated user=${remote.id}');
        } catch (e) {
          debugPrint('[WaterHomeRepo] remote cache failed $e');
        }
      }
      yield remote == null ? null : WaterTrackingHomeMapper.toEntity(remote);
    }
  }

  @override
  Future<void> syncSnapshot() async {
    try {
      final remote = await syncService.fetchRemoteSnapshot();
      if (remote != null) {
        await cacheService.upsertCachedSnapshot(remote);
        debugPrint('[WaterHomeRepo] sync completed user=${remote.id}');
      } else {
        debugPrint('[WaterHomeRepo] sync completed no snapshot');
      }
    } catch (e) {
      debugPrint('[WaterHomeRepo] sync failed $e');
      rethrow;
    }
  }

  void _syncInBackground() {
    syncSnapshot().catchError((e, stack) {
      debugPrint('[WaterHomeRepo] background sync failed $e');
      debugPrint('$stack');
    });
  }
}

