import 'package:flutter/foundation.dart';

import '../../domain/entities/food_tracking_entity.dart';
import '../../domain/repository/food_tracking_home_repository.dart';
import '../mapper/food_tracking_mapper.dart';
import '../../services/food_tracking_home_cache_service.dart';
import '../../services/food_tracking_home_sync_service.dart';

class FoodTrackingHomeRepositoryImpl implements FoodTrackingHomeRepository {
  final FoodTrackingHomeCacheService cacheService;
  final FoodTrackingHomeSyncService syncService;

  FoodTrackingHomeRepositoryImpl({
    required this.cacheService,
    required this.syncService,
  });

  @override
  Future<List<FoodTrackingHomeEntity>> getCachedCycles() async {
    try {
      final local = await cacheService.getCachedCycles();
      _syncInBackground();
      final entities = local.map(FoodTrackingHomeMapper.toEntity).toList();
      debugPrint('[FoodHomeRepo] cached cycles=${local.length} active=${_activeCount(entities)}');
      return entities;
    } catch (e) {
      debugPrint('[FoodHomeRepo] get cached failed $e');
      rethrow;
    }
  }

  @override
  Stream<List<FoodTrackingHomeEntity>> watchCachedCycles() {
    return cacheService
        .watchCachedCycles()
        .map((items) => items.map(FoodTrackingHomeMapper.toEntity).toList());
  }

  @override
  Stream<List<FoodTrackingHomeEntity>> watchRemoteCycles() async* {
    await for (final remote in syncService.watchRemoteCycles()) {
      try {
        await cacheService.upsertCachedCycles(remote);
        debugPrint('[FoodHomeRepo] remote cache updated count=${remote.length}');
      } catch (e) {
        debugPrint('[FoodHomeRepo] remote cache failed $e');
      }
      final entities = remote.map(FoodTrackingHomeMapper.toEntity).toList();
      debugPrint('[FoodHomeRepo] remote active=${_activeCount(entities)}');
      yield entities;
    }
  }

  @override
  Future<void> syncCycles() async {
    try {
      final remote = await syncService.fetchRemoteCycles();
      await cacheService.upsertCachedCycles(remote);
      final entities = remote.map(FoodTrackingHomeMapper.toEntity).toList();
      debugPrint('[FoodHomeRepo] sync completed count=${remote.length} active=${_activeCount(entities)}');
    } catch (e) {
      debugPrint('[FoodHomeRepo] sync failed $e');
      rethrow;
    }
  }

  int _activeCount(List<FoodTrackingHomeEntity> items) {
    return items.where((item) => item.isActive).length;
  }

  void _syncInBackground() {
    syncCycles().catchError((e, stack) {
      debugPrint('[FoodHomeRepo] background sync failed $e');
      debugPrint('$stack');
    });
  }
}
