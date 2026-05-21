import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Track/ElectricityTracking/presentation/provider/electricity_di.dart';
import '../../../../Track/ElectricityTracking/service/FirebaseElectricityService.dart';
import '../../../data/datasource/local/electricity_tracking_local_datasource.dart';
import '../../../data/datasource/remote/electricity_tracking_remote_datasource.dart';
import '../../../data/repository/electricity_tracking_home_repository_impl.dart';
import '../../../domain/repository/electricity_tracking_home_repository.dart';
import '../../../domain/usecases/electricity_tracking/get_electricity_tracking_home_usecase.dart';
import '../../../domain/usecases/electricity_tracking/watch_electricity_tracking_home_usecase.dart';
import '../../../domain/usecases/electricity_tracking/watch_remote_electricity_tracking_home_usecase.dart';
import '../../../domain/usecases/electricity_tracking/sync_electricity_tracking_home_usecase.dart';
import '../../../services/electricity_tracking_analytics_service.dart';
import '../../../services/electricity_tracking_home_cache_service.dart';
import '../../../services/electricity_tracking_home_sync_service.dart';
import 'electricity_tracking_home_notifier.dart';
import '../../../../../core/services/isar_service.dart';

final electricityTrackingHomeServiceProvider = Provider<FirebaseElectricityService>((ref) {
  return FirebaseElectricityService(
    firestore: ref.read(firebaseFirestoreProvider),
    auth: ref.read(firebaseAuthProvider),
  );
});

final electricityTrackingHomeLocalDataSourceProvider =
    Provider<ElectricityTrackingHomeLocalDataSource>((ref) {
  return ElectricityTrackingHomeLocalDataSourceImpl(IsarService.isar);
});

final electricityTrackingHomeRemoteDataSourceProvider =
    Provider<ElectricityTrackingHomeRemoteDataSource>((ref) {
  return ElectricityTrackingHomeRemoteDataSourceImpl(
    service: ref.read(electricityTrackingHomeServiceProvider),
  );
});

final electricityTrackingHomeCacheServiceProvider =
    Provider<ElectricityTrackingHomeCacheService>((ref) {
  return ElectricityTrackingHomeCacheService(
    ref.read(electricityTrackingHomeLocalDataSourceProvider),
  );
});

final electricityTrackingHomeSyncServiceProvider =
    Provider<ElectricityTrackingHomeSyncService>((ref) {
  return ElectricityTrackingHomeSyncService(
    ref.read(electricityTrackingHomeRemoteDataSourceProvider),
  );
});

final electricityTrackingHomeRepositoryProvider =
    Provider<ElectricityTrackingHomeRepository>((ref) {
  return ElectricityTrackingHomeRepositoryImpl(
    cacheService: ref.read(electricityTrackingHomeCacheServiceProvider),
    syncService: ref.read(electricityTrackingHomeSyncServiceProvider),
  );
});

final getElectricityTrackingHomeUseCaseProvider =
    Provider<GetElectricityTrackingHomeUseCase>((ref) {
  return GetElectricityTrackingHomeUseCase(
    ref.read(electricityTrackingHomeRepositoryProvider),
  );
});

final watchElectricityTrackingHomeUseCaseProvider =
    Provider<WatchElectricityTrackingHomeUseCase>((ref) {
  return WatchElectricityTrackingHomeUseCase(
    ref.read(electricityTrackingHomeRepositoryProvider),
  );
});

final watchRemoteElectricityTrackingHomeUseCaseProvider =
    Provider<WatchRemoteElectricityTrackingHomeUseCase>((ref) {
  return WatchRemoteElectricityTrackingHomeUseCase(
    ref.read(electricityTrackingHomeRepositoryProvider),
  );
});

final syncElectricityTrackingHomeUseCaseProvider =
    Provider<SyncElectricityTrackingHomeUseCase>((ref) {
  return SyncElectricityTrackingHomeUseCase(
    ref.read(electricityTrackingHomeRepositoryProvider),
  );
});

final electricityTrackingHomeAnalyticsServiceProvider =
    Provider<ElectricityTrackingHomeAnalyticsService>((ref) {
  return ElectricityTrackingHomeAnalyticsService();
});

final electricityTrackingHomeNotifierProvider = StateNotifierProvider<
    ElectricityTrackingHomeNotifier,
    AsyncValue<ElectricityTrackingHomeAnalytics>>(
  (ref) => ElectricityTrackingHomeNotifier(
    watchLocalUseCase: ref.read(watchElectricityTrackingHomeUseCaseProvider),
    watchRemoteUseCase: ref.read(watchRemoteElectricityTrackingHomeUseCaseProvider),
    syncUseCase: ref.read(syncElectricityTrackingHomeUseCaseProvider),
    analyticsService: ref.read(electricityTrackingHomeAnalyticsServiceProvider),
  ),
);

