import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/model/ExpenseModel.dart';
import '../../data/repository/expense_repository.dart';

class ExpenseViewModel extends ChangeNotifier {
  final ExpenseRepository _repository;

  ExpenseViewModel(this._repository);

  // 📦 State
  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> get expenses => _expenses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // 📊 Summary
  double _totalExpense = 0;
  double get totalExpense => _totalExpense;

  double _totalIncome = 0;
  double get totalIncome => _totalIncome;

  double _balance = 0;
  double get balance => _balance;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  // 🔄 Load All Expenses
  Future<void> loadExpenses() async {
    try {
      _setLoading(true);

      final data = await _repository.getExpenses(userId); // ✅ FIXED
      _expenses = data;

      await _calculateSummary();

      _error = null;
    } catch (e) {
      _error = "Failed to load expenses";
    } finally {
      _setLoading(false);
    }
  }

  // ➕ Add Expense
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      await _repository.addExpense(expense);
      await loadExpenses();
    } catch (e) {
      _error = "Failed to add expense";
      notifyListeners();
    }
  }

  // ❌ Delete Expense (FIXED)
  Future<void> deleteExpense(ExpenseModel expense) async {
    try {
      await _repository.deleteExpense(expense); // ✅ FIXED
      await loadExpenses();
    } catch (e) {
      _error = "Failed to delete expense";
      notifyListeners();
    }
  }

  // ✏️ Update Expense (FIXED)
  Future<void> updateExpense(
      ExpenseModel expense, double oldAmount) async {
    try {
      await _repository.updateExpense(expense, oldAmount); // ✅ FIXED
      await loadExpenses();
    } catch (e) {
      _error = "Failed to update expense";
      notifyListeners();
    }
  }

  // 🔍 Filter by Date
  Future<void> filterByDate(DateTime start, DateTime end) async {
    try {
      _setLoading(true);

      _expenses =
      await _repository.getExpensesByDate(userId, start, end); // ✅ FIXED

      await _calculateSummary();

      _error = null;
    } catch (e) {
      _error = "Filter failed";
    } finally {
      _setLoading(false);
    }
  }

  // 📂 Filter by Category
  Future<void> filterByCategory(String categoryId) async {
    try {
      _setLoading(true);

      _expenses = await _repository.getExpensesByCategory(
          userId, categoryId); // ✅ FIXED

      await _calculateSummary();

      _error = null;
    } catch (e) {
      _error = "Filter failed";
    } finally {
      _setLoading(false);
    }
  }

  // 💳 Filter by Payment Mode
  Future<void> filterByPaymentMode(PaymentMode mode) async {
    try {
      _setLoading(true);

      _expenses =
      await _repository.getByPaymentMode(userId, mode); // ✅ FIXED

      await _calculateSummary();

      _error = null;
    } catch (e) {
      _error = "Filter failed";
    } finally {
      _setLoading(false);
    }
  }

  // 📊 Calculate Summary
  Future<void> _calculateSummary() async {
    _totalExpense = await _repository.getTotalExpense(userId); // ✅ FIXED
    _totalIncome = await _repository.getTotalIncome(userId);   // ✅ FIXED
    _balance = await _repository.getBalance(userId);           // ✅ FIXED
  }

  // 🔄 Loading Handler
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}