import 'package:flutter/foundation.dart';

import '../../data/local/expense_storage.dart';
import '../../data/model/expense_model.dart';
import '../../core/constants/filter_type.dart';

class ExpenseViewModel extends ChangeNotifier {
  ExpenseViewModel(this._storage);

  DateTime? _startDate;
  DateTime? _endDate;

  final ExpenseStorage _storage;

  List<Expense> get expenses => _storage.getExpenses();

  double get totalExpense {
    return expenses.fold<double>(0, (double sum, Expense item) => sum + item.amount);
  }


  FilterType _selectedFilter = FilterType.all;

  FilterType get selectedFilter => _selectedFilter;



  void addExpense({
    required String title,
    required double amount,
    required DateTime date,
  }) {
    final Expense expense = Expense(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      date: date,
    );

    _storage.addExpense(expense);
    notifyListeners();
  }

  void updateExpense({
    required String id,
    required String title,
    required double amount,
    required DateTime date,
  }) {
    final Expense updatedExpense = Expense(
      id: id,
      title: title,
      amount: amount,
      date: date,
    );

    _storage.updateExpense(updatedExpense);
    notifyListeners();
  }

  Expense? removeExpense(String id) {
    final Expense? existing = _storage.getById(id);
    if (existing == null) {
      return null;
    }
    _storage.deleteExpense(id);
    notifyListeners();
    return existing;
  }




  void setFilter(FilterType filter) {
    _selectedFilter = filter;
    _startDate = null;
    _endDate = null;

    notifyListeners();
  }

  List<Expense> get filteredExpenses {
    final now = DateTime.now();

    return expenses.where((expense) {
      final date = expense.date;

      if (_startDate != null && _endDate != null) {
        return date.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
            date.isBefore(_endDate!.add(const Duration(days: 1)));
      }

      switch (_selectedFilter) {
        case FilterType.today:
          return date.day == now.day &&
              date.month == now.month &&
              date.year == now.year;

        case FilterType.yesterday:
          final y = now.subtract(const Duration(days: 1));
          return date.day == y.day &&
              date.month == y.month &&
              date.year == y.year;

        case FilterType.week:
          final start = now.subtract(Duration(days: now.weekday - 1));
          return date.isAfter(start);

        case FilterType.month:
          return date.month == now.month && date.year == now.year;

        case FilterType.year:
          return date.year == now.year;

        case FilterType.all:
          return true;
      }
    }).toList();
  }



  void setCustomRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;

    _selectedFilter = FilterType.all;

    notifyListeners();
  }

}
