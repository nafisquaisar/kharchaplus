import '../entities/water_tracking_entity.dart';

abstract class WaterTrackingHomeRepository {
  Future<WaterTrackingHomeEntity?> getCachedSnapshot();

  Stream<WaterTrackingHomeEntity?> watchCachedSnapshot();

  Stream<WaterTrackingHomeEntity?> watchRemoteSnapshot();

  Future<void> syncSnapshot();
}

