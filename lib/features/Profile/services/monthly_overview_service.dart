import '../data/models/profile_overview_model.dart';

class TrendResult {
  final double percent;
  final bool increased;

  const TrendResult({
    required this.percent,
    required this.increased,
  });
}

class MonthlyOverviewService {
  const MonthlyOverviewService();

  ProfileOverviewModel buildOverview({
    required double currentExpense,
    required double previousExpense,
    required double currentIncome,
    required double previousIncome,
    required double currentElectricityUnits,
    required double previousElectricityUnits,
    required double currentWaterLiters,
    required double previousWaterLiters,
  }) {
    final expenseTrend = _computeTrend(currentExpense, previousExpense);
    final incomeTrend = _computeTrend(currentIncome, previousIncome);
    final electricityTrend =
        _computeTrend(currentElectricityUnits, previousElectricityUnits);
    final waterTrend = _computeTrend(currentWaterLiters, previousWaterLiters);

    return ProfileOverviewModel(
      totalExpense: currentExpense,
      totalIncome: currentIncome,
      electricityUnits: currentElectricityUnits,
      waterIntake: currentWaterLiters,
      expenseTrendPercent: expenseTrend.percent,
      incomeTrendPercent: incomeTrend.percent,
      electricityTrendPercent: electricityTrend.percent,
      waterTrendPercent: waterTrend.percent,
      expenseIncreased: expenseTrend.increased,
      incomeIncreased: incomeTrend.increased,
      electricityIncreased: electricityTrend.increased,
      waterIncreased: waterTrend.increased,
    );
  }

  TrendResult _computeTrend(double current, double previous) {
    if (previous == 0) {
      if (current == 0) {
        return const TrendResult(percent: 0.0, increased: false);
      }
      return TrendResult(percent: 100.0, increased: current > 0);
    }

    final diff = current - previous;
    final percent = (diff.abs() / previous) * 100.0;
    return TrendResult(percent: percent, increased: diff >= 0);
  }
}

