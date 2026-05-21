import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/entities/FoodCycle.dart';

import '../../domain/entities/food_cycle_stats_model.dart';

import '../../domain/enum/cycle_status.dart';
import '../../domain/repository/MealRepository.dart';

import '../../domain/repository/food_repository.dart';

import '../../services/food_cycle_stats_service.dart';
import '../../services/food_cycle_status_service.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../Home/domain/entities/RecentActivityEntity.dart';
import '../../../../Home/domain/usecases/recent/add_recent_activity_usecase.dart';
import '../../../../Home/domain/usecases/recent/update_recent_activity_usecase.dart';
import '../../../../Home/domain/usecases/recent/delete_recent_activity_usecase.dart';

class FoodCycleViewModel extends ChangeNotifier {
  final FoodRepository repository;

  final MealRepository detailRepository;
  final AddRecentActivityUseCase addRecentActivityUseCase;
  final UpdateRecentActivityUseCase updateRecentActivityUseCase;
  final DeleteRecentActivityUseCase deleteRecentActivityUseCase;

  FoodCycleViewModel(
    this.repository,
    this.detailRepository, {
    required this.addRecentActivityUseCase,
    required this.updateRecentActivityUseCase,
    required this.deleteRecentActivityUseCase,
  });

  // =========================
  // STATE
  // =========================

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  final List<FoodCycle> _cycles = [];

  List<FoodCycle> get cycles => List.unmodifiable(_cycles);

  // =========================
  // STATS
  // =========================

  final Map<String, FoodCycleStatsModel> _statsMap = {};

  FoodCycleStatsModel getStats(String cycleId) {
    return _statsMap[cycleId] ?? FoodCycleStatsModel.empty();
  }

  // =========================
  // REALTIME SUBSCRIPTIONS
  // =========================

  final Map<String, StreamSubscription> _mealSubscriptions = {};

  // =========================
  // LOAD CYCLES
  // =========================

  Future<void> loadCycles() async {
    try {
      _setLoading(true);

      _error = null;

      final response = await repository.getAllCycles();

      _cycles
        ..clear()
        ..addAll(response);

      for (int i = 0; i < _cycles.length; i++) {
        final cycle = _cycles[i];

        final updatedCycle = cycle.copyWith(
          status: FoodCycleStatusService.getStatus(cycle),
        );

        _cycles[i] = updatedCycle;
      }

      // =====================
      // START REALTIME STATS
      // =====================

      await _startStatsListeners();
    } catch (e) {
      _error = e.toString();

      debugPrint("Load Cycle Error: $e");
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // CREATE
  // =========================

  Future<void> createCycle(FoodCycle cycle) async {
    try {
      _error = null;

      await repository.createCycle(cycle);

      _cycles.insert(0, cycle);

      _statsMap[cycle.id] = FoodCycleStatsModel.empty();

      // =====================
      // START LISTENER
      // =====================

      await _listenCycleStats(cycle);

      notifyListeners();

      await _syncRecentActivity(cycle: cycle, isUpdate: false);
    } catch (e) {
      _error = e.toString();

      notifyListeners();

      rethrow;
    }
  }

  // =========================
  // UPDATE
  // =========================

  Future<void> updateCycle(FoodCycle cycle) async {
    try {
      _error = null;

      await repository.updateCycle(cycle);

      final index = _cycles.indexWhere((e) => e.id == cycle.id);

      if (index != -1) {
        _cycles[index] = cycle;
      }

      // =====================
      // RESTART LISTENER
      // =====================

      await _listenCycleStats(cycle);

      notifyListeners();

      await _syncRecentActivity(cycle: cycle, isUpdate: true);
    } catch (e) {
      _error = e.toString();

      notifyListeners();

      rethrow;
    }
  }

  // =========================
  // DELETE
  // =========================

  Future<void> deleteCycle(String cycleId) async {
    try {
      _error = null;

      await repository.deleteCycle(cycleId);

      _cycles.removeWhere((e) => e.id == cycleId);

      _statsMap.remove(cycleId);

      // =====================
      // CANCEL LISTENER
      // =====================

      await _mealSubscriptions[cycleId]?.cancel();

      _mealSubscriptions.remove(cycleId);

      notifyListeners();

      await deleteRecentActivityUseCase.call(cycleId);
    } catch (e) {
      _error = e.toString();

      notifyListeners();

      rethrow;
    }
  }

  // =========================
  // START ALL LISTENERS
  // =========================

  Future<void> _startStatsListeners() async {
    // CLEAR OLD

    for (final sub in _mealSubscriptions.values) {
      await sub.cancel();
    }

    _mealSubscriptions.clear();

    // START NEW

    for (final cycle in _cycles) {
      await _listenCycleStats(cycle);
    }
  }

  // =========================
  // SINGLE CYCLE LISTENER
  // =========================

  Future<void> _listenCycleStats(FoodCycle cycle) async {
    // REMOVE OLD

    await _mealSubscriptions[cycle.id]?.cancel();

    // START REALTIME

    final subscription = detailRepository.watchMealEntries(cycle.id).listen((
      meals,
    ) {
      final stats = FoodCycleStatsService.calculate(
        meals: meals,

        totalTiffin: cycle.totalTiffin,

        mealPrice: cycle.mealPrice,
      );

      // =========================
      // UPDATE STATS MAP
      // =========================

      _statsMap[cycle.id] = stats;

      // =========================
      // UPDATE CYCLE STATUS
      // =========================

      final index = _cycles.indexWhere((e) => e.id == cycle.id);

      if (index != -1) {
        final updatedCycle = _cycles[index].copyWith(
          totalEaten: stats.totalMeals,

          remainingTiffin: stats.remaining,

          status: stats.remaining <= 0
              ? CycleStatus.completed
              : FoodCycleStatusService.getStatus(
                  _cycles[index].copyWith(totalEaten: stats.totalMeals),
                ),

          updatedAt: DateTime.now(),
        );

        _cycles[index] = updatedCycle;
      }

      notifyListeners();
    });

    _mealSubscriptions[cycle.id] = subscription;
  }

  // =========================
  // HELPERS
  // =========================

  void _setLoading(bool value) {
    _isLoading = value;

    notifyListeners();
  }

  void clearError() {
    _error = null;

    notifyListeners();
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    for (final sub in _mealSubscriptions.values) {
      sub.cancel();
    }

    super.dispose();
  }

  Future<void> _syncRecentActivity({
    required FoodCycle cycle,
    required bool isUpdate,
  }) async {

    final cycleTitle = (cycle.title ?? '').trim().isEmpty
        ? 'Food Cycle'
        : cycle.title!.trim();

    final dateRange =
        '${AppFormatters.date(cycle.startDate)} - ${AppFormatters.date(cycle.endDate)}';

    debugPrint(
      '[FoodCycle] recent activity sync referenceId=${cycle.id} isUpdate=$isUpdate',
    );


    final recent = RecentActivityEntity(
      id: cycle.id,

      userId: cycle.createdBy,

      type: 'food',

      title: isUpdate
          ? 'Food Cycle Updated'
          : 'Food Cycle Added',

      subtitle: '$cycleTitle • $dateRange',

      amount: cycle.monthlyAmount,

      createdAt: cycle.createdAt,
      updatedAt: cycle.updatedAt,

      referenceId: cycle.id,

      isSynced: false,
      isDeleted: false,
      isEdited: isUpdate,

      version: cycle.version,
    );

    if (isUpdate) {

      await updateRecentActivityUseCase.call(recent);

    } else {

      await addRecentActivityUseCase.call(recent);
    }
  }
}
