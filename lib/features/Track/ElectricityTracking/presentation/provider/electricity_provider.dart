import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/electricity_entity.dart';
import '../../domain/usecases/add_electricity_usecase.dart';
import '../../domain/usecases/delete_electricity_usecase.dart';
import '../../domain/usecases/get_electricity_usecase.dart';
import '../../domain/usecases/search_electricity_usecase.dart';
import '../../domain/usecases/stream_electricity_usecase.dart';
import '../../domain/usecases/sync_pending_electricity_usecase.dart';
import '../../domain/usecases/update_electricity_usecase.dart';
import '../states/electricity_state.dart';

class ElectricityNotifier extends StateNotifier<ElectricityState> {
  final AddElectricityUseCase addUseCase;
  final GetElectricityUseCase getUseCase;
  final UpdateElectricityUseCase updateUseCase;
  final DeleteElectricityUseCase deleteUseCase;
  final SearchElectricityUseCase searchUseCase;
  final StreamElectricityUseCase streamUseCase;
  final SyncPendingElectricityUseCase syncPendingUseCase;

  StreamSubscription<List<ElectricityEntity>>? _subscription;

  ElectricityNotifier({
    required this.addUseCase,
    required this.getUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
    required this.searchUseCase,
    required this.streamUseCase,
    required this.syncPendingUseCase,
  }) : super(ElectricityState.initial());

  // =========================
  // LOAD
  // =========================

  Future<void> loadElectricity({bool showAction = true}) async {
    debugPrint('[Provider] [LOAD START]');
    debugPrint('[LOAD DATA]');
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );
    debugPrint('[STATE UPDATED] isLoading=true');

    try {
      debugPrint('[USECASE EXECUTE] GetElectricityUseCase');
      final list = await getUseCase.execute();
      state = state.copyWith(
        isLoading: false,
        list: list,
        actionId: showAction ? state.actionId + 1 : state.actionId,
        lastAction: showAction ? ElectricityAction.fetchSuccess : state.lastAction,
        actionSuccess: showAction ? true : state.actionSuccess,
        actionMessage: showAction ? 'Fetch success' : state.actionMessage,
        clearActionError: showAction,
      );
      debugPrint('[FETCH SUCCESS] ${list.length}');
      debugPrint('[STATE UPDATED] list=${list.length}');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        actionId: state.actionId + 1,
        lastAction: ElectricityAction.error,
        actionSuccess: false,
        actionError: 'Firebase error: $e',
        clearActionMessage: true,
      );
      debugPrint('[ERROR] $e');
      debugPrint('[STATE UPDATED] error=${state.error}');
    }
  }

  // =========================
  // ADD
  // =========================

  Future<bool> addElectricity(ElectricityEntity entity) async {
    debugPrint('[Provider] [ADD START]');
    state = state.copyWith(isLoading: true, clearError: true);
    debugPrint('[STATE UPDATED] isLoading=true');

    try {
      debugPrint('[USECASE EXECUTE] AddElectricityUseCase');
      await addUseCase.execute(entity);
      await loadElectricity(showAction: false);
      state = state.copyWith(
        actionId: state.actionId + 1,
        lastAction: ElectricityAction.addSuccess,
        actionSuccess: true,
        actionMessage: 'Upload success',
        clearActionError: true,
      );
      debugPrint('[ADD SUCCESS]');
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        actionId: state.actionId + 1,
        lastAction: ElectricityAction.error,
        actionSuccess: false,
        actionError: 'Firebase error: $e',
        clearActionMessage: true,
      );
      debugPrint('[ERROR] $e');
      debugPrint('[STATE UPDATED] error=${state.error}');
      return false;
    }
  }



  // =========================
  // UPDATE
  // =========================

  Future<bool> updateElectricity(ElectricityEntity entity) async {
    debugPrint('[Provider] [UPDATE START]');
    state = state.copyWith(isLoading: true, clearError: true);
    debugPrint('[STATE UPDATED] isLoading=true');

    try {
      debugPrint('[USECASE EXECUTE] UpdateElectricityUseCase');
      await updateUseCase.execute(entity);
      await loadElectricity(showAction: false);
      state = state.copyWith(
        actionId: state.actionId + 1,
        lastAction: ElectricityAction.updateSuccess,
        actionSuccess: true,
        actionMessage: 'Update success',
        clearActionError: true,
      );
      debugPrint('[UPDATE SUCCESS]');
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        actionId: state.actionId + 1,
        lastAction: ElectricityAction.error,
        actionSuccess: false,
        actionError: 'Firebase error: $e',
        clearActionMessage: true,
      );
      debugPrint('[ERROR] $e');
      debugPrint('[STATE UPDATED] error=${state.error}');
      return false;
    }
  }

  // =========================
  // DELETE (SOFT)
  // =========================

  Future<bool> deleteElectricity(String id) async {
    debugPrint('[Provider] [DELETE START] $id');
    state = state.copyWith(isLoading: true, clearError: true);
    debugPrint('[STATE UPDATED] isLoading=true');

    try {
      debugPrint('[USECASE EXECUTE] DeleteElectricityUseCase');
      await deleteUseCase.execute(id);
      await loadElectricity(showAction: false);
      state = state.copyWith(
        actionId: state.actionId + 1,
        lastAction: ElectricityAction.deleteSuccess,
        actionSuccess: true,
        actionMessage: 'Delete success',
        clearActionError: true,
      );
      debugPrint('[DELETE SUCCESS] $id');
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        actionId: state.actionId + 1,
        lastAction: ElectricityAction.error,
        actionSuccess: false,
        actionError: 'Firebase error: $e',
        clearActionMessage: true,
      );
      debugPrint('[ERROR] $e');
      debugPrint('[STATE UPDATED] error=${state.error}');
      return false;
    }
  }

  // =========================
  // SEARCH
  // =========================

  Future<void> searchElectricity(String query) async {
    debugPrint('[Provider] [SEARCH START] $query');
    state = state.copyWith(isSearching: true, clearError: true);
    debugPrint('[STATE UPDATED] isSearching=true');

    try {
      debugPrint('[USECASE EXECUTE] SearchElectricityUseCase');
      final results = await searchUseCase.execute(query);
      state = state.copyWith(
        isSearching: false,
        searchResults: results,
      );
      debugPrint('[Provider] [SEARCH SUCCESS] ${results.length}');
      debugPrint('[STATE UPDATED] searchResults=${results.length}');
    } catch (e) {
      state = state.copyWith(isSearching: false, error: e.toString());
      debugPrint('[ERROR] $e');
      debugPrint('[STATE UPDATED] error=${state.error}');
    }
  }

  // =========================
  // SYNC
  // =========================

  Future<void> syncPending() async {
    debugPrint('[Provider] [SYNC START]');
    state = state.copyWith(isSyncing: true, clearError: true);
    debugPrint('[STATE UPDATED] isSyncing=true');

    try {
      debugPrint('[USECASE EXECUTE] SyncPendingElectricityUseCase');
      await syncPendingUseCase.execute();
      state = state.copyWith(
        isSyncing: false,
        actionId: state.actionId + 1,
        lastAction: ElectricityAction.fetchSuccess,
        actionSuccess: true,
        actionMessage: 'Sync complete',
        clearActionError: true,
      );
      debugPrint('[SYNC COMPLETE]');
      debugPrint('[STATE UPDATED] isSyncing=false');
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        error: e.toString(),
        actionId: state.actionId + 1,
        lastAction: ElectricityAction.error,
        actionSuccess: false,
        actionError: 'Firebase error: $e',
        clearActionMessage: true,
      );
      debugPrint('[ERROR] $e');
      debugPrint('[STATE UPDATED] error=${state.error}');
    }
  }

  // =========================
  // REALTIME
  // =========================

  void startRealtimeListener() {
    debugPrint('[Provider] [REALTIME START]');
    _subscription?.cancel();

    debugPrint('[USECASE EXECUTE] StreamElectricityUseCase');
    _subscription = streamUseCase.execute().listen(
      (items) {
        state = state.copyWith(
          list: items,
          isLoading: false,
        );
        debugPrint('[STREAM UPDATE] ${items.length}');
        debugPrint('[STATE UPDATED] list=${items.length}');
      },
      onError: (error) {
        state = state.copyWith(
          error: error.toString(),
          isLoading: false,
          actionId: state.actionId + 1,
          lastAction: ElectricityAction.error,
          actionSuccess: false,
          actionError: 'Firebase error: $error',
          clearActionMessage: true,
        );
        debugPrint('[ERROR] $error');
        debugPrint('[STATE UPDATED] error=${state.error}');
      },
    );
  }

  void consumeAction(int actionId) {
    if (state.consumedActionId == actionId) {
      return;
    }
    state = state.copyWith(consumedActionId: actionId);
    debugPrint('[ACTION CONSUMED] $actionId');
  }
}
