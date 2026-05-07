import 'package:flutter/material.dart';

import '../../data/model/ExpenseFilterModel.dart';
import '../../data/model/ExpenseModel.dart';

class ExpenseFilterViewModel
    extends ChangeNotifier {

  ExpenseFilterModel _filter =
  const ExpenseFilterModel();

  ExpenseFilterModel get filter =>
      _filter;

  ExpenseType? get selectedType =>
      _filter.type;

  // =========================
  // APPLY FILTER
  // =========================

  void applyFilter(
      ExpenseFilterModel filter,
      ) {

    _filter = filter;

    notifyListeners();
  }

  // =========================
  // QUICK FILTER
  // =========================

  void setQuickFilter(
      ExpenseType? type,
      ) {

    _filter = _filter.copyWith(
      type: type,
    );

    notifyListeners();
  }

  // =========================
  // CLEAR FILTER
  // =========================

  void clearFilters() {

    _filter =
    const ExpenseFilterModel();

    notifyListeners();
  }

  // =========================
  // FILTERED DATA
  // =========================

  List<ExpenseModel> filterExpenses(
      List<ExpenseModel> expenses,
      ) {

    List<ExpenseModel> data =
    List.from(expenses);

    /// TYPE FILTER

    if (_filter.type != null) {

      data = data.where((e) {

        return e.type ==
            _filter.type;

      }).toList();
    }

    /// CATEGORY FILTER

    if (_filter.categoryId != null) {

      data = data.where((e) {

        return e.categoryId ==
            _filter.categoryId;

      }).toList();
    }

    /// PAYMENT FILTER

    if (_filter.paymentMode != null) {

      data = data.where((e) {

        return e.paymentMode ==
            _filter.paymentMode;

      }).toList();
    }

    /// DATE FILTER

    if (_filter.startDate != null &&
        _filter.endDate != null) {

      data = data.where((e) {

        return e.date.isAfter(
          _filter.startDate!
              .subtract(
            const Duration(days: 1),
          ),
        ) &&
            e.date.isBefore(
              _filter.endDate!
                  .add(
                const Duration(days: 1),
              ),
            );

      }).toList();
    }

    /// SORT

    switch (_filter.sortType) {

      case ExpenseSortType.latest:

        data.sort(
              (a, b) =>
              b.date.compareTo(a.date),
        );

        break;

      case ExpenseSortType.oldest:

        data.sort(
              (a, b) =>
              a.date.compareTo(b.date),
        );

        break;

      case ExpenseSortType.highest:

        data.sort(
              (a, b) =>
              b.amount.compareTo(a.amount),
        );

        break;

      case ExpenseSortType.lowest:

        data.sort(
              (a, b) =>
              a.amount.compareTo(b.amount),
        );

        break;
    }

    return data;
  }
}