import 'package:flutter/foundation.dart';

import '../../Track/WaterTracking/domain/usecases/sync/sync_water_data.dart';
import '../data/datasource/remote/water_tracking_remote_datasource.dart';
import '../data/models/water_tracking_model.dart';

class WaterTrackingHomeSyncService {
  final WaterTrackingHomeRemoteDataSource remoteDataSource;
  final SyncWaterData syncWaterData;

  WaterTrackingHomeSyncService({
    required this.remoteDataSource,
    required this.syncWaterData,
  });

  Future<WaterTrackingHomeModel?> fetchRemoteSnapshot() async {
    final report = await syncWaterData.call();
    if (report.skipped) {
      debugPrint('[WaterHomeSync] Firestore sync skipped reason=${report.reason}');
    } else {
      debugPrint('[WaterHomeSync] Firestore sync success uploaded=${report.uploaded} downloaded=${report.downloaded}');
    }
    return remoteDataSource.buildSnapshot();
  }

  Stream<WaterTrackingHomeModel?> watchRemoteSnapshot() {
    return remoteDataSource.watchSnapshot();
  }
}
