import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../features/Expense/data/model/ExpenseCardModel.dart';
import '../../features/Expense/data/model/ExpenseModel.dart';
import '../../features/Home/domain/entities/RecentActivityEntity.dart';
import '../../features/Home/domain/repository/RecentActivityRepository.dart';

class RecentActivityService {

  final RecentActivityRepository repository;

  RecentActivityService(this.repository);

  // =========================
  // EXPENSE CYCLE
  // =========================

  Future<void> addExpenseCycleCreated(
      ExpenseCardModel card,
      ) async {

    final activity = _buildExpenseCycleActivity(
      card,
      title: 'Expense Cycle Created',
    );

    debugPrint(
      '[RecentActivityService] create expense_cycle id=${activity.id} referenceId=${activity.referenceId} parentCardId=${activity.parentCardId} userId=${activity.userId}',
    );

    try {

      await repository.addActivity(activity);

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

  Future<void> updateExpenseCycle(
      ExpenseCardModel card,
      ) async {

    final activity = _buildExpenseCycleActivity(
      card,
      title: 'Expense Cycle Updated',
    );

    debugPrint(
      '[RecentActivityService] update expense_cycle id=${activity.id} referenceId=${activity.referenceId} parentCardId=${activity.parentCardId} userId=${activity.userId}',
    );

    try {

      await repository.updateActivity(activity);

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

  Future<void> deleteExpenseCycle(
      String cardId,
      ) async {

    try {

      await repository.deleteActivity(cardId);

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

  // =========================
  // EXPENSE ITEM
  // =========================

  Future<void> addExpenseItemCreated(
      ExpenseModel expense,
      ) async {

    final activity = _buildExpenseItemActivity(
      expense,
      title: 'Expense Added',
    );

    debugPrint(
      '[RecentActivityService] create expense_item id=${activity.id} referenceId=${activity.referenceId} parentCardId=${activity.parentCardId} userId=${activity.userId}',
    );

    try {

      await repository.addActivity(activity);

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

  Future<void> updateExpenseItem(
      ExpenseModel expense,
      ) async {

    final activity = _buildExpenseItemActivity(
      expense,
      title: 'Expense Updated',
    );

    debugPrint(
      '[RecentActivityService] update expense_item id=${activity.id} referenceId=${activity.referenceId} parentCardId=${activity.parentCardId} userId=${activity.userId}',
    );

    try {

      await repository.updateActivity(activity);

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

  Future<void> deleteExpenseItem(
      String expenseId,
      ) async {

    try {

      await repository.deleteActivity(expenseId);

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

  // =========================
  // BUILD EXPENSE CYCLE
  // =========================

  RecentActivityEntity _buildExpenseCycleActivity(
      ExpenseCardModel card, {
        required String title,
      }) {

    final now = DateTime.now();

    return RecentActivityEntity(
      id: card.id,

      userId: card.userId,

      type: 'expense_cycle',

      title: title,

      subtitle: _formatSubtitle(card),

      amount: card.totalBudget,

      createdAt: now,
      updatedAt: now,

      referenceId: card.id,

      isSynced: false,
      isDeleted: false,
      isEdited: false,

      version: 1,
    );
  }

  // =========================
  // BUILD EXPENSE ITEM
  // =========================

  RecentActivityEntity _buildExpenseItemActivity(
      ExpenseModel expense, {
        required String title,
      }) {

    final now = DateTime.now();

    return RecentActivityEntity(
      id: expense.id,

      userId: expense.userId,

      type: 'expense_item',

      title: title,

      subtitle: _formatExpenseSubtitle(expense),

      amount: expense.amount,

      createdAt: now,
      updatedAt: now,

      referenceId: expense.id,

      parentCardId: expense.cardId,

      isSynced: false,
      isDeleted: false,
      isEdited: false,

      version: 1,
    );
  }

  // =========================
  // FORMATTERS
  // =========================

  String _formatSubtitle(
      ExpenseCardModel card,
      ) {

    final month = DateFormat(
      'MMM yyyy',
    ).format(card.startDate);

    return '${card.title} - $month';
  }

  String _formatExpenseSubtitle(
      ExpenseModel expense,
      ) {

    final note = (expense.note ?? '').trim();

    if (note.isNotEmpty) {
      return '$note - ${expense.categoryName}';
    }

    return expense.categoryName;
  }
}