import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../features/Expense/data/model/ExpenseCardModel.dart';
import '../../features/Expense/data/model/ExpenseModel.dart';

import '../../features/Home/domain/entities/RecentActivityEntity.dart';
import '../../features/Home/domain/repository/RecentActivityRepository.dart';

class RecentActivityService {

  final RecentActivityRepository repository;

  final FirebaseAuth auth;

  RecentActivityService(
      this.repository,
      this.auth,
      );

  String? get _userId =>
      auth.currentUser?.uid;

  // =====================================================
  // EXPENSE CYCLE CREATE
  // =====================================================

  Future<void> addExpenseCycleCreated(
      ExpenseCardModel card,
      ) async {

    final activity =
    _buildExpenseCycleActivity(
      card,
      title: 'Expense Cycle Created',
    );

    try {

      await repository.addActivity(
        activity,
      );

      debugPrint(
        '[RecentActivityService] expense cycle created added ${card.id}',
      );

    } catch (e, stack) {

      debugPrint(
        '[RecentActivityService] expense cycle created add failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // EXPENSE CYCLE UPDATE
  // =====================================================

  Future<void> updateExpenseCycle(
      ExpenseCardModel card,
      ) async {

    final activity =
    _buildExpenseCycleActivity(
      card,
      title: 'Expense Cycle Updated',
    );

    try {

      await repository.updateActivity(
        activity,
      );

      debugPrint(
        '[RecentActivityService] expense cycle updated ${card.id}',
      );

    } catch (e, stack) {

      debugPrint(
        '[RecentActivityService] expense cycle update failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // EXPENSE CYCLE DELETE
  // =====================================================

  Future<void> deleteExpenseCycle(
      String cardId,
      ) async {

    final userId = _userId;

    if (userId == null) {
      return;
    }

    try {

      await repository.deleteActivity(
        cardId,
        userId,
      );

      debugPrint(
        '[RecentActivityService] expense cycle deleted $cardId',
      );

    } catch (e, stack) {

      debugPrint(
        '[RecentActivityService] expense cycle delete failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // EXPENSE ITEM CREATE
  // =====================================================

  Future<void> addExpenseItemCreated(
      ExpenseModel expense,
      ) async {

    final activity =
    _buildExpenseItemActivity(
      expense,
      title: 'Expense Added',
    );

    try {

      await repository.addActivity(
        activity,
      );

      debugPrint(
        '[RecentActivityService] expense item added ${expense.id}',
      );

    } catch (e, stack) {

      debugPrint(
        '[RecentActivityService] expense item add failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // EXPENSE ITEM UPDATE
  // =====================================================

  Future<void> updateExpenseItem(
      ExpenseModel expense,
      ) async {

    final activity =
    _buildExpenseItemActivity(
      expense,
      title: 'Expense Updated',
    );

    try {

      await repository.updateActivity(
        activity,
      );

      debugPrint(
        '[RecentActivityService] expense item updated ${expense.id}',
      );

    } catch (e, stack) {

      debugPrint(
        '[RecentActivityService] expense item update failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // EXPENSE ITEM DELETE
  // =====================================================

  Future<void> deleteExpenseItem(
      String expenseId,
      ) async {

    final userId = _userId;

    if (userId == null) {
      return;
    }

    try {

      await repository.deleteActivity(
        expenseId,
        userId,
      );

      debugPrint(
        '[RecentActivityService] expense item deleted $expenseId',
      );

    } catch (e, stack) {

      debugPrint(
        '[RecentActivityService] expense item delete failed $e',
      );

      debugPrint('$stack');

      rethrow;
    }
  }

  // =====================================================
  // BUILD EXPENSE CYCLE
  // =====================================================

  RecentActivityEntity
  _buildExpenseCycleActivity(
      ExpenseCardModel card, {

        required String title,
      }) {

    final userId = _userId ?? '';

    return RecentActivityEntity(

      id: card.id,

      userId: userId,

      type: 'expense_cycle',

      title: title,

      subtitle: _formatSubtitle(card),

      amount: card.totalBudget,

      createdAt: DateTime.now(),

      updatedAt: DateTime.now(),

      referenceId: card.id,

      isSynced: false,

      isDeleted: false,

      isEdited: false,

      version: 1,
    );
  }

  // =====================================================
  // FORMAT SUBTITLE
  // =====================================================

  String _formatSubtitle(
      ExpenseCardModel card,
      ) {

    final month = DateFormat(
      'MMM yyyy',
    ).format(
      card.startDate,
    );

    return '${card.title} - $month';
  }

  // =====================================================
  // BUILD EXPENSE ITEM
  // =====================================================

  RecentActivityEntity
  _buildExpenseItemActivity(
      ExpenseModel expense, {

        required String title,
      }) {

    final userId = _userId ?? '';

    return RecentActivityEntity(

      id: expense.id,

      userId: userId,

      type: 'expense_item',

      title: title,

      subtitle: _formatExpenseSubtitle(
        expense,
      ),

      amount: expense.amount,

      createdAt: DateTime.now(),

      updatedAt: DateTime.now(),

      referenceId: expense.id,

      isSynced: false,

      isDeleted: false,

      isEdited: false,

      version: 1,
    );
  }

  // =====================================================
  // FORMAT EXPENSE SUBTITLE
  // =====================================================

  String _formatExpenseSubtitle(
      ExpenseModel expense,
      ) {

    final note =
    (expense.note ?? '').trim();

    if (note.isNotEmpty) {

      return '$note - ${expense.categoryName}';
    }

    return expense.categoryName;
  }
}