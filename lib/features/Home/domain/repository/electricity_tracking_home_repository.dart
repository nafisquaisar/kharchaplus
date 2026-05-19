import '../entities/electricity_tracking_entity.dart';

abstract class ElectricityTrackingHomeRepository {
  Future<List<ElectricityTrackingHomeEntity>> getCachedCycles();

  Stream<List<ElectricityTrackingHomeEntity>> watchCachedCycles();

  Stream<List<ElectricityTrackingHomeEntity>> watchRemoteCycles();

  Future<void> syncCycles();
}

