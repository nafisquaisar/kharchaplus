import 'package:flutter/foundation.dart';

import '../../domain/entities/electricity_tracking_entity.dart';
import '../../domain/repository/electricity_tracking_home_repository.dart';
import '../mapper/electricity_tracking_mapper.dart';
import '../../services/electricity_tracking_home_cache_service.dart';
import '../../services/electricity_tracking_home_sync_service.dart';

class ElectricityTrackingHomeRepositoryImpl
    implements ElectricityTrackingHomeRepository {
  final ElectricityTrackingHomeCacheService cacheService;
  final ElectricityTrackingHomeSyncService syncService;

  ElectricityTrackingHomeRepositoryImpl({
    required this.cacheService,
    required this.syncService,
  });

  @override
  Future<List<ElectricityTrackingHomeEntity>> getCachedCycles() async {
    try {
      final local = await cacheService.getCachedCycles();
      _syncInBackground();
      final entities =
          local.map(ElectricityTrackingHomeMapper.toEntity).toList();
      debugPrint(
        '[ElectricityHomeRepo] cached cycles=${local.length}',
      );
      return entities;
    } catch (e) {
      debugPrint('[ElectricityHomeRepo] get cached failed $e');
      rethrow;
    }
  }

  @override
  Stream<List<ElectricityTrackingHomeEntity>> watchCachedCycles() {
    return cacheService
        .watchCachedCycles()
        .map((items) => items.map(ElectricityTrackingHomeMapper.toEntity).toList());
  }

  @override
  Stream<List<ElectricityTrackingHomeEntity>> watchRemoteCycles() async* {
    await for (final remote in syncService.watchRemoteCycles()) {
      try {
        await cacheService.upsertCachedCycles(remote);
        debugPrint(
          '[ElectricityHomeRepo] remote cache updated count=${remote.length}',
        );
      } catch (e) {
        debugPrint('[ElectricityHomeRepo] remote cache failed $e');
      }
      final entities =
          remote.map(ElectricityTrackingHomeMapper.toEntity).toList();
      debugPrint('[ElectricityHomeRepo] remote count=${entities.length}');
      yield entities;
    }
  }

  @override
  Future<void> syncCycles() async {
    try {
      final remote = await syncService.fetchRemoteCycles();
      await cacheService.upsertCachedCycles(remote);
      debugPrint(
        '[ElectricityHomeRepo] sync completed count=${remote.length}',
      );
    } catch (e) {
      debugPrint('[ElectricityHomeRepo] sync failed $e');
      rethrow;
    }
  }

  void _syncInBackground() {
    syncCycles().catchError((e, stack) {
      debugPrint('[ElectricityHomeRepo] background sync failed $e');
      debugPrint('$stack');
    });
  }
}

