import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/model/ExpenseCardModel.dart';
import '../../data/repository/ExpenseCardRepository.dart';

class ExpenseCardViewModel extends ChangeNotifier {
  final ExpenseCardRepository _repo;

  ExpenseCardViewModel(this._repo);

  StreamSubscription<List<ExpenseCardModel>>? _cardSubscription;

  // =====================================================
  // STATE
  // =====================================================

  List<ExpenseCardModel> _cards = [];

  List<ExpenseCardModel> get cards => _cards;

  bool _isInitialLoading = false;

  bool get isInitialLoading => _isInitialLoading;

  bool _isRefreshing = false;

  bool get isRefreshing => _isRefreshing;

  bool _isMutating = false;

  bool get isMutating => _isMutating;

  String? _error;

  String? get error => _error;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  bool _hasLoadedOnce = false;

  bool get hasLoadedOnce => _hasLoadedOnce;

  // =====================================================
  // REALTIME LISTENER
  // =====================================================

  void listenCards(String userId) {
    _isInitialLoading = true;

    notifyListeners();

    _cardSubscription?.cancel();

    _cardSubscription = _repo.getCards(userId).listen(
          (data) {
        _cards = data;

        _error = null;

        _isInitialLoading = false;

        _hasLoadedOnce = true;

        notifyListeners();
      },

      onError: (e) {
        _error = "Failed to load cards";

        _isInitialLoading = false;

        _hasLoadedOnce = true;

        notifyListeners();
      },
    );
  }


  // =====================================================
  // REFRESH
  // =====================================================

  Future<void> refreshCards() async {
    try {
      if (_isRefreshing) {
        return;
      }

      _isRefreshing = true;

      notifyListeners();

      /// realtime stream already active
      await Future.delayed(const Duration(milliseconds: 700));

      _error = null;
    } catch (e) {
      _error = "Refresh failed";
    } finally {
      _isRefreshing = false;

      notifyListeners();
    }
  }

  // =====================================================
  // CREATE CARD
  // =====================================================

  Future<void> addCard(ExpenseCardModel card) async {
    try {
      _isMutating = true;

      notifyListeners();

      await _repo.addCard(card);

      _error = null;
    } catch (e) {
      _error = "Failed to create card";

      notifyListeners();
    } finally {
      _isMutating = false;

      notifyListeners();
    }
  }

  // =====================================================
  // UPDATE CARD
  // =====================================================

  Future<void> updateCard(ExpenseCardModel card) async {
    try {
      _isMutating = true;

      notifyListeners();

      await _repo.updateCard(card);

      _error = null;
    } catch (e) {
      _error = "Failed to update card";

      notifyListeners();
    } finally {
      _isMutating = false;

      notifyListeners();
    }
  }

  // =====================================================
  // DELETE CARD
  // =====================================================

  Future<void> deleteCard(String userId, String cardId) async {
    try {
      _isMutating = true;

      notifyListeners();

      await _repo.deleteCard(userId: userId, cardId: cardId);
      _error = null;
    } catch (e) {
      _error = "Failed to delete card";

      notifyListeners();
    } finally {
      _isMutating = false;

      notifyListeners();
    }
  }

  // =====================================================
  // CLEAR ERROR
  // =====================================================

  void clearError() {
    _error = null;

    notifyListeners();
  }

  // =====================================================
  // RESET
  // =====================================================

  void reset() {
    _cards = [];

    _isInitialLoading = false;

    _isRefreshing = false;

    _isMutating = false;

    _hasLoadedOnce = false;

    _error = null;

    notifyListeners();
  }
  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    _cardSubscription?.cancel();

    super.dispose();
  }
}
