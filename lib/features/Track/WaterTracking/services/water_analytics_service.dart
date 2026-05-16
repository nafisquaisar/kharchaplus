import '../domain/entities/water_intake_entity.dart';
import '../domain/entities/water_purchase_entity.dart';
import '../domain/enum/payment_status.dart';
import '../domain/enum/purchase_type.dart';
import 'water_calculation_service.dart';

class WaterAnalyticsService {
  final WaterCalculationService _calc = WaterCalculationService();

  WaterIntakeAnalytics calculateWaterIntakeAnalytics({
    required List<WaterIntakeEntity> todayIntake,
    required List<WaterIntakeEntity> weeklyIntake,
    required List<WaterIntakeEntity> monthlyIntake,
    required int dailyGoalMl,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();

    final todayTotal = _calc.totalIntakeMl(todayIntake);
    final weeklyTotal = _calc.totalIntakeMl(weeklyIntake);
    final monthlyTotal = _calc.totalIntakeMl(monthlyIntake);

    final daysElapsed = reference.day > 0 ? reference.day : 1;
    final averageDaily =
        monthlyTotal == 0 ? 0 : (monthlyTotal / daysElapsed).round();

    final percent = dailyGoalMl == 0 ? 0.0 : todayTotal / dailyGoalMl;
    final remaining = dailyGoalMl - todayTotal;

    return WaterIntakeAnalytics(
      todayMl: todayTotal,
      weeklyMl: weeklyTotal,
      monthlyMl: monthlyTotal,
      averageDailyMl: averageDaily,
      intakePercent: percent.clamp(0.0, 1.0),
      remainingMl: remaining <= 0 ? 0 : remaining,
      dailyGoalMl: dailyGoalMl,
    );
  }

  StreakAnalytics calculateStreakAnalytics({
    required List<WaterIntakeEntity> intake,
    DateTime? now,
  }) {
    final result = _calc.calculateStreaks(
      intake,
      now: now,
    );

    return StreakAnalytics(
      uniqueDays: result.uniqueDays,
      currentStreak: result.currentStreak,
      bestStreak: result.bestStreak,
    );
  }

  ExpenseAnalytics calculateExpenseAnalytics({
    required List<WaterPurchaseEntity> purchases,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final monthStart = DateTime(reference.year, reference.month, 1);
    final monthEnd = DateTime(reference.year, reference.month + 1, 1);
    final prevStart = DateTime(reference.year, reference.month - 1, 1);
    final prevEnd = DateTime(reference.year, reference.month, 1);

    var monthlyExpense = 0.0;
    var totalPurchases = 0;
    var previousExpense = 0.0;
    var totalUnpaidAmount = 0.0;
    var pendingAmount = 0.0;
    var paidPurchases = 0;
    final monthlyPurchases = <WaterPurchaseEntity>[];

    for (final item in purchases) {
      if (!item.date.isBefore(monthStart) && item.date.isBefore(monthEnd)) {
        monthlyExpense += item.price;
        totalPurchases += 1;
        monthlyPurchases.add(item);

        if (item.paymentStatus == PaymentStatus.paid) {
          paidPurchases += 1;
        }
        if (item.paymentStatus == PaymentStatus.unpaid) {
          totalUnpaidAmount += item.price;
        }
        if (item.paymentStatus.isPending) {
          pendingAmount += item.price;
        }
      } else if (!item.date.isBefore(prevStart) &&
          item.date.isBefore(prevEnd)) {
        previousExpense += item.price;
      }
    }

    final averageCost =
        totalPurchases == 0 ? 0.0 : monthlyExpense / totalPurchases;

    final breakdown = _calc.calculatePurchaseBreakdown(monthlyPurchases);

    return ExpenseAnalytics(
      monthlyExpense: monthlyExpense,
      previousMonthExpense: previousExpense,
      averagePurchaseCost: averageCost,
      totalPurchases: totalPurchases,
      purchaseCountByType: breakdown.countByType,
      purchaseCostByType: breakdown.costByType,
      totalUnpaidAmount: totalUnpaidAmount,
      paidPurchases: paidPurchases,
      pendingAmount: pendingAmount,
    );
  }

  WeeklyChartAnalytics calculateWeeklyChartAnalytics({
    required List<WaterIntakeEntity> weeklyIntake,
    DateTime? now,
  }) {
    final map = _calc.groupWeeklyLitersByWeekday(
      intake: weeklyIntake,
      now: now,
    );

    return WeeklyChartAnalytics(
      litersByWeekday: [
        map[1] ?? 0,
        map[2] ?? 0,
        map[3] ?? 0,
        map[4] ?? 0,
        map[5] ?? 0,
        map[6] ?? 0,
        map[7] ?? 0,
      ],
    );
  }
}

class WaterIntakeAnalytics {
  final int todayMl;
  final int weeklyMl;
  final int monthlyMl;
  final int averageDailyMl;
  final double intakePercent;
  final int remainingMl;
  final int dailyGoalMl;

  const WaterIntakeAnalytics({
    required this.todayMl,
    required this.weeklyMl,
    required this.monthlyMl,
    required this.averageDailyMl,
    required this.intakePercent,
    required this.remainingMl,
    required this.dailyGoalMl,
  });
}

class StreakAnalytics {
  final int uniqueDays;
  final int currentStreak;
  final int bestStreak;

  const StreakAnalytics({
    required this.uniqueDays,
    required this.currentStreak,
    required this.bestStreak,
  });
}

class ExpenseAnalytics {
  final double monthlyExpense;
  final double previousMonthExpense;
  final double averagePurchaseCost;
  final int totalPurchases;
  final Map<PurchaseType, int> purchaseCountByType;
  final Map<PurchaseType, double> purchaseCostByType;
  final double totalUnpaidAmount;
  final int paidPurchases;
  final double pendingAmount;

  const ExpenseAnalytics({
    required this.monthlyExpense,
    required this.previousMonthExpense,
    required this.averagePurchaseCost,
    required this.totalPurchases,
    required this.purchaseCountByType,
    required this.purchaseCostByType,
    required this.totalUnpaidAmount,
    required this.paidPurchases,
    required this.pendingAmount,
  });
}

class WeeklyChartAnalytics {
  final List<double> litersByWeekday;

  const WeeklyChartAnalytics({
    required this.litersByWeekday,
  });
}
