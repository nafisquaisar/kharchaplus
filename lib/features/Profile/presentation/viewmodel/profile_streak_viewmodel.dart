import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/profile_stats_model.dart';
import '../../data/repository/profile_stats_repository.dart';

class ProfileStreakViewModel extends ChangeNotifier {
  final ProfileStatsRepository _repository;

  StreamSubscription<ProfileStatsModel?>? _statsSubscription;
  StreamSubscription<void>? _monthlyGoalSubscription;
  String? _userId;
  ProfileStatsModel? _stats;
  bool _isSyncing = false;
  String? _errorMessage;

  ProfileStreakViewModel(this._repository);

  ProfileStatsModel? get stats => _stats;
  int get currentStreak => _stats?.currentStreak ?? 0;
  double get monthlyGoalPercent => _stats?.monthlyGoalPercent ?? 0;
  String get monthlyGoalLabel => '${monthlyGoalPercent.toStringAsFixed(0)}%';
  bool get isSyncing => _isSyncing;
  String? get errorMessage => _errorMessage;

  void bindUser(String? uid) {
    if (_userId == uid) {
      return;
    }

    _userId = uid;
    _statsSubscription?.cancel();
    _statsSubscription = null;
    _monthlyGoalSubscription?.cancel();
    _monthlyGoalSubscription = null;
    _stats = null;
    _errorMessage = null;
    notifyListeners();

    if (uid == null || uid.isEmpty) {
      return;
    }

    _statsSubscription = _repository.watchStats(uid).listen(
      (stats) {
        _stats = stats;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        notifyListeners();
      },
    );

    _monthlyGoalSubscription = _repository
        .watchMonthlyGoalChanges(uid)
        .listen((_) => _repository.recomputeMonthlyGoal(uid));

    recordAppOpen();
  }

  Future<void> recordAppOpen() async {
    if (_userId == null || _userId!.isEmpty) {
      return;
    }

    if (_isSyncing) {
      return;
    }

    _isSyncing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.recordAppOpen(_userId!);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> syncPending() async {
    if (_userId == null || _userId!.isEmpty) {
      return;
    }

    if (_isSyncing) {
      return;
    }

    _isSyncing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.syncPending(_userId!);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _statsSubscription?.cancel();
    _monthlyGoalSubscription?.cancel();
    super.dispose();
  }
}
