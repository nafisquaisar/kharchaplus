import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/electricity_tracking/sync_electricity_tracking_home_usecase.dart';
import '../../../domain/usecases/electricity_tracking/watch_electricity_tracking_home_usecase.dart';
import '../../../domain/usecases/electricity_tracking/watch_remote_electricity_tracking_home_usecase.dart';
import '../../../services/electricity_tracking_analytics_service.dart';

class ElectricityTrackingHomeNotifier
    extends StateNotifier<AsyncValue<ElectricityTrackingHomeAnalytics>> {
  final WatchElectricityTrackingHomeUseCase watchLocalUseCase;
  final WatchRemoteElectricityTrackingHomeUseCase watchRemoteUseCase;
  final SyncElectricityTrackingHomeUseCase syncUseCase;
  final ElectricityTrackingHomeAnalyticsService analyticsService;
  StreamSubscription? _localSub;
  StreamSubscription? _remoteSub;

  ElectricityTrackingHomeNotifier({
    required this.watchLocalUseCase,
    required this.watchRemoteUseCase,
    required this.syncUseCase,
    required this.analyticsService,
  }) : super(const AsyncLoading()) {
    _bindLocal();
    _bindRemote();
    _bootstrap();
  }

  void _bindLocal() {
    _localSub?.cancel();
    _localSub = watchLocalUseCase.call().listen(
      (items) {
        debugPrint('[ElectricityHomeNotifier] cache updated count=${items.length}');
        state = AsyncData(analyticsService.build(items));
      },
      onError: (e, stack) {
        debugPrint('[ElectricityHomeNotifier] local error $e');
        state = AsyncError(e, stack);
      },
    );
  }

  void _bindRemote() {
    _remoteSub?.cancel();
    _remoteSub = watchRemoteUseCase.call().listen(
      (_) {},
      onError: (e, stack) {
        debugPrint('[ElectricityHomeNotifier] remote error $e');
        if (state is AsyncLoading) {
          state = AsyncError(e, stack);
        }
      },
    );
  }

  Future<void> _bootstrap() async {
    try {
      await syncUseCase.call();
      debugPrint('[ElectricityHomeNotifier] sync success');
    } catch (e, stack) {
      debugPrint('[ElectricityHomeNotifier] sync failed $e');
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

