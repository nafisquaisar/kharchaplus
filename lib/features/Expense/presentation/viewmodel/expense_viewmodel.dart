import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/model/ExpenseModel.dart';
import '../../data/repository/expense_repository.dart';

class ExpenseViewModel extends ChangeNotifier {

  final ExpenseRepository _repository;

  ExpenseViewModel(this._repository);

  StreamSubscription<List<ExpenseModel>>?
  _expenseSubscription;

  // =========================================================
  // STATE
  // =========================================================

  List<ExpenseModel> _expenses = [];

  List<ExpenseModel> get expenses =>
      _expenses;

  /// INITIAL SCREEN LOADING
  bool _isInitialLoading = false;

  bool get isInitialLoading =>
      _isInitialLoading;

  /// PULL TO REFRESH
  bool _isRefreshing = false;

  bool get isRefreshing =>
      _isRefreshing;

  /// ADD / UPDATE / DELETE
  bool _isMutating = false;

  bool get isMutating =>
      _isMutating;

  /// ERROR
  String? _error;

  String? get error =>
      _error;

  /// CURRENT USER
  String get userId =>
      FirebaseAuth
          .instance
          .currentUser!
          .uid;

  // =========================================================
  // SUMMARY
  // =========================================================

  double _totalExpense = 0;

  double get totalExpense =>
      _totalExpense;

  double _totalIncome = 0;

  double get totalIncome =>
      _totalIncome;

  double _balance = 0;

  double get balance =>
      _balance;

  // =========================================================
  // REALTIME ALL EXPENSES
  // =========================================================

  void listenExpenses() {

    if (_expenses.isEmpty) {

      _isInitialLoading = true;

      notifyListeners();
    }

    _expenseSubscription?.cancel();

    _expenseSubscription =
        _repository
            .streamExpenses(userId)
            .listen(

              (data) {

            _expenses = data;

            _calculateSummaryWithoutNotify();

            _error = null;

            _isInitialLoading = false;

            notifyListeners();
          },

          onError: (e) {

            _error =
            "Realtime sync failed";

            _isInitialLoading = false;

            notifyListeners();
          },
        );
  }

  // =========================================================
  // REALTIME CARD EXPENSES
  // =========================================================

  void listenExpensesByCard(
      String cardId,
      ) {

    if (_expenses.isEmpty) {

      _isInitialLoading = true;

      notifyListeners();
    }

    _expenseSubscription?.cancel();

    _expenseSubscription =
        _repository
            .getExpensesByCard(
          userId,
          cardId,
        )
            .listen(

              (data) {

            _expenses = data;

            _calculateSummaryWithoutNotify();

            _error = null;

            _isInitialLoading = false;

            _isRefreshing = false;

            notifyListeners();
          },

          onError: (e) {

            _error =
            "Realtime sync failed";

            _isInitialLoading = false;

            _isRefreshing = false;

            notifyListeners();
          },
        );
  }

  // =========================================================
  // PULL REFRESH
  // =========================================================

  Future<void> refreshExpenses(
      String cardId,
      ) async {

    try {

      /// already refreshing
      if (_isRefreshing) {
        return;
      }

      _isRefreshing = true;

      notifyListeners();

      /// simulate refresh delay
      /// realtime stream already active hai
      await Future.delayed(
        const Duration(
          milliseconds: 700,
        ),
      );

      _error = null;

    } catch (e) {

      _error =
      "Refresh failed";

    } finally {

      _isRefreshing = false;

      notifyListeners();
    }
  }


  // =========================================================
  // ADD EXPENSE
  // =========================================================

  Future<void> addExpense(
      ExpenseModel expense,
      ) async {

    try {

      _isMutating = true;

      notifyListeners();

      await _repository
          .addExpense(expense);

      _error = null;

    } catch (e) {

      _error = e.toString();

      notifyListeners();

      rethrow;

    } finally {

      _isMutating = false;

      notifyListeners();
    }
  }

  // =========================================================
  // UPDATE EXPENSE
  // =========================================================

  Future<void> updateExpense(
      ExpenseModel expense,
      double oldAmount,
      ) async {

    try {

      _isMutating = true;

      notifyListeners();

      await _repository
          .updateExpense(
        expense,
        oldAmount,
      );

      _error = null;

    } catch (e) {

      _error =
      "Failed to update expense";

      notifyListeners();

    } finally {

      _isMutating = false;

      notifyListeners();
    }
  }

  // =========================================================
  // HARD DELETE
  // =========================================================

  Future<void> deleteExpense(
      ExpenseModel expense,
      ) async {

    try {

      _isMutating = true;

      notifyListeners();

      await _repository
          .deleteExpense(expense);

      _error = null;

    } catch (e) {

      _error =
      "Failed to delete expense";

      notifyListeners();

    } finally {

      _isMutating = false;

      notifyListeners();
    }
  }

  // =========================================================
  // SOFT DELETE
  // =========================================================

  Future<void> softDeleteExpense(
      ExpenseModel expense,
      ) async {

    try {

      _isMutating = true;

      notifyListeners();

      final deletedExpense =
      expense.copyWith(

        isDeleted: true,

        updatedAt:
        DateTime.now(),
      );

      await _repository
          .updateExpense(
        deletedExpense,
        expense.amount,
      );

      _error = null;

    } catch (e) {

      _error =
      "Failed to delete expense";

      notifyListeners();

    } finally {

      _isMutating = false;

      notifyListeners();
    }
  }

  // =========================================================
  // FILTER DATE
  // =========================================================

  Future<void> filterByDate(
      DateTime start,
      DateTime end,
      ) async {

    try {

      _isInitialLoading = true;

      notifyListeners();

      _expenses =
      await _repository
          .getExpensesByDate(
        userId,
        start,
        end,
      );

      _calculateSummaryWithoutNotify();

      _error = null;

    } catch (e) {

      _error = "Filter failed";

    } finally {

      _isInitialLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // FILTER CATEGORY
  // =========================================================

  Future<void> filterByCategory(
      String categoryId,
      ) async {

    try {

      _isInitialLoading = true;

      notifyListeners();

      _expenses =
      await _repository
          .getExpensesByCategory(
        userId,
        categoryId,
      );

      _calculateSummaryWithoutNotify();

      _error = null;

    } catch (e) {

      _error = "Filter failed";

    } finally {

      _isInitialLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // FILTER PAYMENT MODE
  // =========================================================

  Future<void> filterByPaymentMode(
      PaymentMode mode,
      ) async {

    try {

      _isInitialLoading = true;

      notifyListeners();

      _expenses =
      await _repository
          .getByPaymentMode(
        userId,
        mode,
      );

      _calculateSummaryWithoutNotify();

      _error = null;

    } catch (e) {

      _error = "Filter failed";

    } finally {

      _isInitialLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // SUMMARY
  // =========================================================

  void _calculateSummaryWithoutNotify() {

    _totalExpense = _expenses
        .where(
          (e) =>
      !e.isDeleted &&
          e.type ==
              ExpenseType.expense,
    )
        .fold(
      0.0,
          (sum, e) =>
      sum + e.amount,
    );

    _totalIncome = _expenses
        .where(
          (e) =>
      !e.isDeleted &&
          e.type ==
              ExpenseType.income,
    )
        .fold(
      0.0,
          (sum, e) =>
      sum + e.amount,
    );

    _balance =
        _totalIncome -
            _totalExpense;
  }

  // =========================================================
  // CLEAR ERROR
  // =========================================================

  void clearError() {

    _error = null;

    notifyListeners();
  }

  // =========================================================
  // RESET STATE
  // =========================================================

  void reset() {

    _expenses = [];

    _totalExpense = 0;

    _totalIncome = 0;

    _balance = 0;

    _error = null;

    _isInitialLoading = false;

    _isRefreshing = false;

    _isMutating = false;

    notifyListeners();
  }




  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {

    _expenseSubscription?.cancel();

    super.dispose();
  }
}