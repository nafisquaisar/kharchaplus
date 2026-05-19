import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/isar_service.dart';
import '../../../data/datasource/local/food_tracking_local_datasource.dart';
import '../../../data/datasource/remote/food_tracking_remote_datasource.dart';
import '../../../data/repository/food_tracking_home_repository_impl.dart';
import '../../../domain/repository/food_tracking_home_repository.dart';
import '../../../domain/usecases/food_tracking/get_food_tracking_home_usecase.dart';
import '../../../domain/usecases/food_tracking/watch_food_tracking_home_usecase.dart';
import '../../../domain/usecases/food_tracking/watch_remote_food_tracking_home_usecase.dart';
import '../../../domain/usecases/food_tracking/sync_food_tracking_home_usecase.dart';
import '../../../services/food_tracking_home_cache_service.dart';
import '../../../services/food_tracking_home_sync_service.dart';
import 'food_tracking_home_notifier.dart';
import '../../../domain/entities/food_tracking_entity.dart';

final foodTrackingHomeLocalDataSourceProvider =
    Provider<FoodTrackingHomeLocalDataSource>((ref) {
  return FoodTrackingHomeLocalDataSourceImpl(IsarService.isar);
});

final foodTrackingHomeRemoteDataSourceProvider =
    Provider<FoodTrackingHomeRemoteDataSource>((ref) {
  return FoodTrackingHomeRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final foodTrackingHomeCacheServiceProvider =
    Provider<FoodTrackingHomeCacheService>((ref) {
  return FoodTrackingHomeCacheService(
    ref.read(foodTrackingHomeLocalDataSourceProvider),
  );
});

final foodTrackingHomeSyncServiceProvider =
    Provider<FoodTrackingHomeSyncService>((ref) {
  return FoodTrackingHomeSyncService(
    ref.read(foodTrackingHomeRemoteDataSourceProvider),
  );
});

final foodTrackingHomeRepositoryProvider =
    Provider<FoodTrackingHomeRepository>((ref) {
  return FoodTrackingHomeRepositoryImpl(
    cacheService: ref.read(foodTrackingHomeCacheServiceProvider),
    syncService: ref.read(foodTrackingHomeSyncServiceProvider),
  );
});

final getFoodTrackingHomeUseCaseProvider =
    Provider<GetFoodTrackingHomeUseCase>((ref) {
  return GetFoodTrackingHomeUseCase(
    ref.read(foodTrackingHomeRepositoryProvider),
  );
});

final watchFoodTrackingHomeUseCaseProvider =
    Provider<WatchFoodTrackingHomeUseCase>((ref) {
  return WatchFoodTrackingHomeUseCase(
    ref.read(foodTrackingHomeRepositoryProvider),
  );
});

final watchRemoteFoodTrackingHomeUseCaseProvider =
    Provider<WatchRemoteFoodTrackingHomeUseCase>((ref) {
  return WatchRemoteFoodTrackingHomeUseCase(
    ref.read(foodTrackingHomeRepositoryProvider),
  );
});

final syncFoodTrackingHomeUseCaseProvider =
    Provider<SyncFoodTrackingHomeUseCase>((ref) {
  return SyncFoodTrackingHomeUseCase(
    ref.read(foodTrackingHomeRepositoryProvider),
  );
});

final foodTrackingHomeNotifierProvider = StateNotifierProvider<
    FoodTrackingHomeNotifier,
    AsyncValue<List<FoodTrackingHomeEntity>>>(
  (ref) => FoodTrackingHomeNotifier(
    watchLocalUseCase: ref.read(watchFoodTrackingHomeUseCaseProvider),
    watchRemoteUseCase: ref.read(watchRemoteFoodTrackingHomeUseCaseProvider),
    syncUseCase: ref.read(syncFoodTrackingHomeUseCaseProvider),
  ),
);
