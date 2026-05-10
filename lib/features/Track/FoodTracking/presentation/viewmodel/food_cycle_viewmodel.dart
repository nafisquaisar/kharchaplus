import 'package:flutter/material.dart';

import '../../domain/entities/FoodCycle.dart';
import '../../domain/repository/food_repository.dart';

class FoodCycleViewModel extends ChangeNotifier {

  final FoodRepository repository;

  FoodCycleViewModel(
      this.repository,
      );

  // =========================
  // STATE
  // =========================

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  final List<FoodCycle> _cycles = [];

  List<FoodCycle> get cycles =>
      List.unmodifiable(_cycles);

  // =========================
  // LOAD CYCLES
  // =========================

  Future<void> loadCycles() async {

    try {

      _setLoading(true);

      _error = null;

      final response =
      await repository.getAllCycles();

      _cycles
        ..clear()
        ..addAll(response);

    } catch (e) {

      _error = e.toString();

    } finally {

      _setLoading(false);
    }
  }

  // =========================
  // CREATE CYCLE
  // =========================

  Future<void> createCycle(
      FoodCycle cycle,
      ) async {

    try {

      _error = null;

      await repository.createCycle(cycle);

      _cycles.insert(0, cycle);

      notifyListeners();

    } catch (e) {

      _error = e.toString();

      notifyListeners();

      rethrow;
    }
  }

  // =========================
  // UPDATE CYCLE
  // =========================

  Future<void> updateCycle(
      FoodCycle cycle,
      ) async {

    try {

      _error = null;

      await repository.updateCycle(cycle);

      final index = _cycles.indexWhere(
            (e) => e.id == cycle.id,
      );

      if (index != -1) {

        _cycles[index] = cycle;

      }

      notifyListeners();

    } catch (e) {

      _error = e.toString();

      notifyListeners();

      rethrow;
    }
  }

  // =========================
  // DELETE CYCLE
  // =========================

  Future<void> deleteCycle(
      String cycleId,
      ) async {

    try {

      _error = null;

      await repository.deleteCycle(cycleId);

      _cycles.removeWhere(
            (e) => e.id == cycleId,
      );

      notifyListeners();

    } catch (e) {

      _error = e.toString();

      notifyListeners();

      rethrow;
    }
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
}