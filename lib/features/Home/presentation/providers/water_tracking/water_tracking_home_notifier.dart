import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/water_tracking_entity.dart';
import '../../../domain/usecases/water_tracking/sync_water_tracking_home_usecase.dart';
import '../../../domain/usecases/water_tracking/watch_remote_water_tracking_home_usecase.dart';
import '../../../domain/usecases/water_tracking/watch_water_tracking_home_usecase.dart';

class WaterTrackingHomeNotifier
    extends StateNotifier<AsyncValue<WaterTrackingHomeEntity?>> {
  final WatchWaterTrackingHomeUseCase watchLocalUseCase;
  final WatchRemoteWaterTrackingHomeUseCase watchRemoteUseCase;
  final SyncWaterTrackingHomeUseCase syncUseCase;
  StreamSubscription<WaterTrackingHomeEntity?>? _localSub;
  StreamSubscription<WaterTrackingHomeEntity?>? _remoteSub;

  WaterTrackingHomeNotifier({
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
      (snapshot) {
        debugPrint('[WaterHomeNotifier] cache updated hasData=${snapshot != null}');
        debugPrint('[WaterHomeNotifier] home card updated');
        state = AsyncData(snapshot);
      },
      onError: (e, stack) {
        debugPrint('[WaterHomeNotifier] local error $e');
        state = AsyncError(e, stack);
      },
    );
  }

  void _bindRemote() {
    _remoteSub?.cancel();
    _remoteSub = watchRemoteUseCase.call().listen(
      (_) {},
      onError: (e, stack) {
        debugPrint('[WaterHomeNotifier] remote error $e');
        if (state is AsyncLoading) {
          state = AsyncError(e, stack);
        }
      },
    );
  }

  Future<void> _bootstrap() async {
    try {
      await syncUseCase.call();
      debugPrint('[WaterHomeNotifier] sync success');
    } catch (e, stack) {
      debugPrint('[WaterHomeNotifier] sync failed $e');
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
