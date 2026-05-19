import '../data/datasource/local/water_tracking_local_datasource.dart';
import '../data/models/water_tracking_model.dart';
import 'package:flutter/foundation.dart';

class WaterTrackingHomeCacheService {
  final WaterTrackingHomeLocalDataSource localDataSource;

  WaterTrackingHomeCacheService(this.localDataSource);

  Future<WaterTrackingHomeModel?> getCachedSnapshot(String userId) {
    return localDataSource.getSnapshot(userId);
  }

  Stream<WaterTrackingHomeModel?> watchCachedSnapshot(String userId) {
    return localDataSource.watchSnapshot(userId);
  }

  Future<void> upsertCachedSnapshot(WaterTrackingHomeModel snapshot) {
    debugPrint('[WaterHomeCache] Isar cache updated user=${snapshot.id}');
    return localDataSource.upsertSnapshot(snapshot);
  }
}
