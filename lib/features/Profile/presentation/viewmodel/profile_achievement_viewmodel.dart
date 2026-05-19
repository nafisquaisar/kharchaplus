import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/profile_achievement_model.dart';
import '../../data/repository/profile_achievement_repository.dart';
import '../../services/achievement_catalog.dart';

class ProfileAchievementViewModel extends ChangeNotifier {
  final ProfileAchievementRepository _repository;

  StreamSubscription<List<ProfileAchievementModel>>? _subscription;
  String? _userId;
  List<ProfileAchievementModel> _items = const [];
  AchievementCategory? _selectedCategory;
  bool _isBusy = false;
  String? _errorMessage;

  ProfileAchievementViewModel(this._repository);

  List<ProfileAchievementModel> get items => _items;
  AchievementCategory? get selectedCategory => _selectedCategory;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;

  List<ProfileAchievementModel> get filteredItems {
    if (_selectedCategory == null) {
      return _sortedItems(_items);
    }
    return _sortedItems(
      _items
          .where((item) => item.category == _selectedCategory!.name)
          .toList(),
    );
  }

  int get unlockedCount =>
      _items.where((item) => item.isUnlocked).length;

  void bindUser(String? uid) {
    if (_userId == uid) {
      return;
    }

    _userId = uid;
    _subscription?.cancel();
    _subscription = null;
    _items = const [];
    _errorMessage = null;
    notifyListeners();

    if (uid == null || uid.isEmpty) {
      return;
    }

    _subscription = _repository.watchAchievements(uid).listen(
      (items) {
        _items = items;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        notifyListeners();
      },
    );

    refreshFromRemote();
    evaluateAndSync();
  }

  void setCategory(AchievementCategory? category) {
    if (_selectedCategory == category) {
      return;
    }
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> evaluateAndSync() async {
    if (_userId == null || _userId!.isEmpty) {
      return;
    }
    if (_isBusy) {
      return;
    }

    _isBusy = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.evaluateAndSync(_userId!);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> refreshFromRemote() async {
    if (_userId == null || _userId!.isEmpty) {
      return;
    }

    try {
      await _repository.refreshFromRemote(_userId!);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<ProfileAchievementModel> _sortedItems(
    List<ProfileAchievementModel> items,
  ) {
    final sorted = [...items];
    sorted.sort((a, b) {
      if (a.isUnlocked != b.isUnlocked) {
        return a.isUnlocked ? -1 : 1;
      }
      final aTime = a.unlockedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.unlockedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return sorted;
  }
}
