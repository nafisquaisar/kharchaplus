import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/food_tracking_entity.dart';
import '../../../domain/usecases/food_tracking/sync_food_tracking_home_usecase.dart';
import '../../../domain/usecases/food_tracking/watch_food_tracking_home_usecase.dart';
import '../../../domain/usecases/food_tracking/watch_remote_food_tracking_home_usecase.dart';

class FoodTrackingHomeNotifier
    extends StateNotifier<AsyncValue<List<FoodTrackingHomeEntity>>> {
  final WatchFoodTrackingHomeUseCase watchLocalUseCase;
  final WatchRemoteFoodTrackingHomeUseCase watchRemoteUseCase;
  final SyncFoodTrackingHomeUseCase syncUseCase;
  StreamSubscription<List<FoodTrackingHomeEntity>>? _localSub;
  StreamSubscription<List<FoodTrackingHomeEntity>>? _remoteSub;

  FoodTrackingHomeNotifier({
    required this.watchLocalUseCase,
    required this.watchRemoteUseCase,
    required this.syncUseCase,
  }) : super(const AsyncLoading()) {
    _bindLocal();
    _bindRemote();
    _bootstrap();
  }

  void _bindLocal() {
    _localSub?.cancel();
    _localSub = watchLocalUseCase.call().listen(
      (items) {
        debugPrint('[FoodHomeNotifier] cache updated count=${items.length}');
        state = AsyncData(items);
      },
      onError: (e, stack) {
        debugPrint('[FoodHomeNotifier] local error $e');
        state = AsyncError(e, stack);
      },
    );
  }

  void _bindRemote() {
    _remoteSub?.cancel();
    _remoteSub = watchRemoteUseCase.call().listen(
      (_) {},
      onError: (e, stack) {
        debugPrint('[FoodHomeNotifier] remote error $e');
        if (state is AsyncLoading) {
          state = AsyncError(e, stack);
        }
      },
    );
  }

  Future<void> _bootstrap() async {
    try {
      await syncUseCase.call();
      debugPrint('[FoodHomeNotifier] sync success');
    } catch (e, stack) {
      debugPrint('[FoodHomeNotifier] sync failed $e');
      if (state is AsyncLoading) {
        state = AsyncError(e, stack);
      }
    }
  }

  Future<void> refresh() async {
    await syncUseCase.call();
  }

  @override
  void dispose() {
    _localSub?.cancel();
    _remoteSub?.cancel();
    super.dispose();
  }
}
