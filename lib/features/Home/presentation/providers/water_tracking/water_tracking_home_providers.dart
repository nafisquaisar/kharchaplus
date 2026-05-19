import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Track/WaterTracking/presentation/providers/intake/intake_provider.dart';
import '../../../../Track/WaterTracking/presentation/providers/sync/sync_provider.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/services/isar_service.dart';
import '../../../data/datasource/local/water_tracking_local_datasource.dart';
import '../../../data/datasource/remote/water_tracking_remote_datasource.dart';
import '../../../data/repository/water_tracking_home_repository_impl.dart';
import '../../../domain/entities/water_tracking_entity.dart';
import '../../../domain/repository/water_tracking_home_repository.dart';
import '../../../domain/usecases/water_tracking/get_water_tracking_home_usecase.dart';
import '../../../domain/usecases/water_tracking/watch_remote_water_tracking_home_usecase.dart';
import '../../../domain/usecases/water_tracking/watch_water_tracking_home_usecase.dart';
import '../../../domain/usecases/water_tracking/sync_water_tracking_home_usecase.dart';
import '../../../services/water_tracking_home_analytics_service.dart';
import '../../../services/water_tracking_home_cache_service.dart';
import '../../../services/water_tracking_home_sync_service.dart';
import 'water_tracking_home_notifier.dart';

final waterTrackingHomeLocalDataSourceProvider =
    Provider<WaterTrackingHomeLocalDataSource>((ref) {
  return WaterTrackingHomeLocalDataSourceImpl(IsarService.isar);
});

final waterTrackingHomeAnalyticsServiceProvider =
    Provider<WaterTrackingHomeAnalyticsService>((ref) {
  return WaterTrackingHomeAnalyticsService();
});

final waterTrackingHomeRemoteDataSourceProvider =
    Provider<WaterTrackingHomeRemoteDataSource>((ref) {
  return WaterTrackingHomeRemoteDataSourceImpl(
    waterRepository: ref.read(waterRepositoryProvider),
    analyticsService: ref.read(waterTrackingHomeAnalyticsServiceProvider),
    authService: ref.read(authServiceProvider),
    isar: IsarService.isar,
  );
});

final waterTrackingHomeCacheServiceProvider =
    Provider<WaterTrackingHomeCacheService>((ref) {
  return WaterTrackingHomeCacheService(
    ref.read(waterTrackingHomeLocalDataSourceProvider),
  );
});

final waterTrackingHomeSyncServiceProvider =
    Provider<WaterTrackingHomeSyncService>((ref) {
  return WaterTrackingHomeSyncService(
    remoteDataSource: ref.read(waterTrackingHomeRemoteDataSourceProvider),
    syncWaterData: ref.read(syncWaterDataProvider),
  );
});

final waterTrackingHomeRepositoryProvider =
    Provider<WaterTrackingHomeRepository>((ref) {
  return WaterTrackingHomeRepositoryImpl(
    cacheService: ref.read(waterTrackingHomeCacheServiceProvider),
    syncService: ref.read(waterTrackingHomeSyncServiceProvider),
    authService: ref.read(authServiceProvider),
  );
});

final getWaterTrackingHomeUseCaseProvider =
    Provider<GetWaterTrackingHomeUseCase>((ref) {
  return GetWaterTrackingHomeUseCase(
    ref.read(waterTrackingHomeRepositoryProvider),
  );
});

final watchWaterTrackingHomeUseCaseProvider =
    Provider<WatchWaterTrackingHomeUseCase>((ref) {
  return WatchWaterTrackingHomeUseCase(
    ref.read(waterTrackingHomeRepositoryProvider),
  );
});

final watchRemoteWaterTrackingHomeUseCaseProvider =
    Provider<WatchRemoteWaterTrackingHomeUseCase>((ref) {
  return WatchRemoteWaterTrackingHomeUseCase(
    ref.read(waterTrackingHomeRepositoryProvider),
  );
});

final syncWaterTrackingHomeUseCaseProvider =
    Provider<SyncWaterTrackingHomeUseCase>((ref) {
  return SyncWaterTrackingHomeUseCase(
    ref.read(waterTrackingHomeRepositoryProvider),
  );
});

final waterTrackingHomeNotifierProvider = StateNotifierProvider<
    WaterTrackingHomeNotifier,
    AsyncValue<WaterTrackingHomeEntity?>>(
  (ref) => WaterTrackingHomeNotifier(
    watchLocalUseCase: ref.read(watchWaterTrackingHomeUseCaseProvider),
    watchRemoteUseCase: ref.read(watchRemoteWaterTrackingHomeUseCaseProvider),
    syncUseCase: ref.read(syncWaterTrackingHomeUseCaseProvider),
  ),
);

