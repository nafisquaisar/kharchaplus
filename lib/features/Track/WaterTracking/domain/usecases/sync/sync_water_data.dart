import '../../repository/water_sync_repository.dart';
import '../../../services/water_sync_service.dart';

class SyncWaterData {
  final WaterSyncRepository repository;

  SyncWaterData(this.repository);

  Future<WaterSyncReport> call({
    SyncProgressCallback? onProgress,
  }) {
    return repository.syncAll(onProgress: onProgress);
  }
}

