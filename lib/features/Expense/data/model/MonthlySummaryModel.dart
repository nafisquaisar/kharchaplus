class MonthlySummaryModel {

  final String month;

  final double totalExpense;
  final double totalIncome;
  final double remainingBalance;

  final int totalTransactions;

  final int totalExpenseTransactions;
  final int totalIncomeTransactions;

  final double previousMonthExpense;
  final double previousMonthIncome;

  final double expenseGrowthPercent;
  final double incomeGrowthPercent;

  final DateTime createdAt;
  final DateTime updatedAt;

  MonthlySummaryModel({
    required this.month,
    required this.totalExpense,
    required this.totalIncome,
    required this.remainingBalance,
    required this.totalTransactions,
    required this.totalExpenseTransactions,
    required this.totalIncomeTransactions,
    required this.previousMonthExpense,
    required this.previousMonthIncome,
    required this.expenseGrowthPercent,
    required this.incomeGrowthPercent,
    required this.createdAt,
    required this.updatedAt,
  });
}