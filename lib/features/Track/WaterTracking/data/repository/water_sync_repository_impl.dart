import '../../domain/repository/water_sync_repository.dart';
import '../../services/water_sync_service.dart';

class WaterSyncRepositoryImpl implements WaterSyncRepository {
  final WaterSyncService service;

  WaterSyncRepositoryImpl({
    required this.service,
  });

  @override
  Future<WaterSyncReport> syncAll({
    SyncProgressCallback? onProgress,
  }) {
    return service.syncAll(onProgress: onProgress);
  }
}

