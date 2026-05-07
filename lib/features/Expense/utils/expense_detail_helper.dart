import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/model/ExpenseCardModel.dart';
import '../data/model/ExpenseFilterModel.dart';
import '../data/model/ExpenseModel.dart';
import '../presentation/bottomsheet/ExpenseFilterBottomSheet/ExpenseFilterBottomSheet.dart';
import '../presentation/viewmodel/ExpenseFilterViewModel.dart';
import '../presentation/viewmodel/expense_viewmodel.dart';



class ExpenseDetailHelper {

  /// =========================
  /// TOTAL EXPENSE
  /// =========================

  static double calculateExpense(
      List<ExpenseModel> expenses,
      ) {

    return expenses

        .where(
          (e) =>
      e.type ==
          ExpenseType.expense,
    )

        .fold(
      0.0,
          (sum, e) =>
      sum + e.amount,
    );
  }

  /// =========================
  /// TOTAL INCOME
  /// =========================

  static double calculateIncome(
      List<ExpenseModel> expenses,
      ) {

    return expenses

        .where(
          (e) =>
      e.type ==
          ExpenseType.income,
    )

        .fold(
      0.0,
          (sum, e) =>
      sum + e.amount,
    );
  }

  /// =========================
  /// BALANCE
  /// =========================

  static double calculateBalance({

    required double income,

    required double expense,
  }) {

    return income - expense;
  }

  /// =========================
  /// DATE FORMAT
  /// =========================

  static String formatDate(
      DateTime date,
      ) {

    return DateFormat(
      "dd MMM",
    ).format(date);
  }

  /// =========================
  /// REFRESH
  /// =========================

  static Future<void> refreshExpenses({

    required BuildContext context,

    required String cardId,
  }) async {

    await context
        .read<ExpenseViewModel>()
        .refreshExpenses(
      cardId,
    );
  }

  /// =========================
  /// RETRY
  /// =========================

  static void retry({

    required BuildContext context,

    required String cardId,
  }) {

    context
        .read<ExpenseViewModel>()
        .listenExpensesByCard(
      cardId,
    );
  }

  /// =========================
  /// FILTER SHEET
  /// =========================

  static Future<void> openFilterSheet({

    required BuildContext context,

    required ExpenseFilterViewModel filterVM,
  }) async {

    final result =
    await showModalBottomSheet<
        ExpenseFilterModel>(

      context: context,

      isScrollControlled: true,

      backgroundColor:
      Colors.transparent,

      builder: (_) {

        return ExpenseFilterBottomSheet(

          initialFilter:
          filterVM.filter,
        );
      },
    );

    if (result == null) {
      return;
    }

    filterVM.applyFilter(
      result,
    );
  }


  static ExpenseCardModel? getRecentCompletedCard({required List<ExpenseCardModel> cards, required String currentCardId,}) {

    final completedCards = cards

        .where((card) {

      return card.id != currentCardId &&

          getCardStatus(card) ==
              "completed";
    })

        .toList()

      ..sort(
            (a, b) =>
            b.endDate.compareTo(
              a.endDate,
            ),
      );

    if (completedCards.isEmpty) {
      return null;
    }

    return completedCards.first;
  }

  static String getCardStatus(ExpenseCardModel card,) {

    final now = DateTime.now();

    if (card.endDate.isBefore(now)) {

      return "completed";
    }

    if (card.startDate.isAfter(now)) {

      return "upcoming";
    }

    return "active";
  }

  static String generateCardTrend({required double currentAmount, required double previousAmount,}) {

    if (previousAmount <= 0) {

      return "No previous data";
    }

    final diff =
        currentAmount -
            previousAmount;

    final percent =
        (diff / previousAmount) * 100;

    final absPercent =
    percent.abs().toStringAsFixed(1);

    if (percent > 0) {

      return
        "$absPercent% more than previous completed card";
    }

    if (percent < 0) {

      return
        "$absPercent% less than previous completed card";
    }

    return "Same as previous completed card";
  }

  static double calculateCardExpense({required List<ExpenseModel> expenses, required String cardId,}) {

    return expenses

        .where((e) {

      return e.cardId == cardId &&

          !e.isDeleted &&

          e.type ==
              ExpenseType.expense;
    })

        .fold(
      0.0,
          (sum, e) =>
      sum + e.amount,
    );
  }

  static double calculateCurrentMonthExpense(List<ExpenseModel> expenses,) {

    final now = DateTime.now();

    return expenses

        .where((e) {

      return e.type ==
          ExpenseType.expense &&

          e.date.month ==
              now.month &&

          e.date.year ==
              now.year;
    })

        .fold(
      0.0,
          (sum, e) =>
      sum + e.amount,
    );
  }

  static double calculatePreviousMonthExpense(List<ExpenseModel> expenses,) {

    final now = DateTime.now();

    final previousMonth =
    now.month == 1
        ? 12
        : now.month - 1;

    final previousYear =
    now.month == 1
        ? now.year - 1
        : now.year;

    return expenses

        .where((e) {

      return e.type ==
          ExpenseType.expense &&

          e.date.month ==
              previousMonth &&

          e.date.year ==
              previousYear;
    })

        .fold(
      0.0,
          (sum, e) =>
      sum + e.amount,
    );
  }





}