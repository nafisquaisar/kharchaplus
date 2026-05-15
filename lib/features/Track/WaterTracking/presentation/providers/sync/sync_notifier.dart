import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/sync/sync_water_data.dart';
import 'sync_state.dart';

class WaterSyncNotifier extends StateNotifier<SyncState> {
  WaterSyncNotifier({
    required this.syncWaterData,
    required this.connectivity,
  }) : super(SyncState.initial());

  final SyncWaterData syncWaterData;
  final Connectivity connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectionSub;
  Timer? _periodicTimer;
  bool _started = false;

  void start() {
    if (_started) return;
    _started = true;

    _connectionSub = connectivity.onConnectivityChanged.listen((results) {
      final isOnline = results.any((result) => result != ConnectivityResult.none);
      if (isOnline) {
        syncNow();
      }
    });

    _periodicTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => syncNow(),
    );

    syncNow();
  }

  Future<void> syncNow() async {
    if (state.isSyncing) return;

    state = state.copyWith(
      isSyncing: true,
      progress: 0,
      error: null,
    );

    try {
      final report = await syncWaterData(
        onProgress: (progress) {
          state = state.copyWith(progress: progress);
        },
      );

      if (!report.skipped) {
        state = state.copyWith(
          isSyncing: false,
          progress: 1,
          lastSyncAt: DateTime.now(),
          error: null,
        );
      } else {
        state = state.copyWith(
          isSyncing: false,
          error: report.reason,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        error: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    _connectionSub?.cancel();
    _periodicTimer?.cancel();
    super.dispose();
  }
}
