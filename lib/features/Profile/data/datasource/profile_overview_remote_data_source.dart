import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class MonthlyExpenseIncomeSnapshot {
  final double totalExpense;
  final double totalIncome;

  const MonthlyExpenseIncomeSnapshot({
    required this.totalExpense,
    required this.totalIncome,
  });
}

abstract class ProfileOverviewRemoteDataSource {
  Future<MonthlyExpenseIncomeSnapshot> getMonthlyExpenseIncome(
    String uid,
    DateTime month,
  );

  Future<double> getMonthlyElectricityUnits(
    String uid,
    DateTime month,
  );
}

class ProfileOverviewRemoteDataSourceImpl
    implements ProfileOverviewRemoteDataSource {
  static const String _usersCollection = 'users';
  static const String _monthlySummaryCollection = 'monthly_summary';
  static const String _electricityCyclesCollection = 'electricity_cycles';

  final FirebaseFirestore _firestore;

  ProfileOverviewRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<MonthlyExpenseIncomeSnapshot> getMonthlyExpenseIncome(
    String uid,
    DateTime month,
  ) async {
    final monthId = _monthId(month);
    final docRef = _firestore
        .collection(_usersCollection)
        .doc(uid)
        .collection(_monthlySummaryCollection)
        .doc(monthId);

    try {
      final snapshot = await docRef.get();
      final data = snapshot.data();
      if (data == null) {
        return const MonthlyExpenseIncomeSnapshot(
          totalExpense: 0.0,
          totalIncome: 0.0,
        );
      }
      return MonthlyExpenseIncomeSnapshot(
        totalExpense:
            _readDouble(data['totalExpense'] ?? data['total_expense']),
        totalIncome: _readDouble(data['totalIncome'] ?? data['total_income']),
      );
    } catch (e) {
      throw ProfileOverviewRemoteDataSourceException(
        'Failed to fetch monthly expense/income for "$uid" at "$monthId".',
        cause: e,
      );
    }
  }

  @override
  Future<double> getMonthlyElectricityUnits(
    String uid,
    DateTime month,
  ) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    try {
      final query = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .collection(_electricityCyclesCollection)
          .where('isDeleted', isEqualTo: false)
          .where('endDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('endDate', isLessThan: Timestamp.fromDate(end))
          .get();

      double total = 0.0;
      for (final doc in query.docs) {
        final data = doc.data();
        final prevUnit = (data['prevUnit'] as num?)?.toDouble() ?? 0.0;
        final currentUnit = (data['currentUnit'] as num?)?.toDouble() ?? 0.0;
        final diff = currentUnit - prevUnit;
        if (diff > 0) {
          total += diff;
        }
      }
      return total;
    } catch (e) {
      throw ProfileOverviewRemoteDataSourceException(
        'Failed to fetch monthly electricity usage for "$uid" at "${_monthId(month)}".',
        cause: e,
      );
    }
  }

  String _monthId(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}-$month';
  }

  double _readDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}

class ProfileOverviewRemoteDataSourceException implements Exception {
  final String message;
  final Object? cause;

  const ProfileOverviewRemoteDataSourceException(
    this.message, {
    this.cause,
  });

  @override
  String toString() {
    if (cause == null) {
      return message;
    }
    return '$message Cause: $cause';
  }
}
