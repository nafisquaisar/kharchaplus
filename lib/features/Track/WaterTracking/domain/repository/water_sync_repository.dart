import '../../services/water_sync_service.dart';

typedef SyncProgressCallback = void Function(double progress);

abstract class WaterSyncRepository {
  Future<WaterSyncReport> syncAll({
    SyncProgressCallback? onProgress,
  });
}

