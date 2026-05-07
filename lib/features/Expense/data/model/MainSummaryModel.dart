class MainSummaryModel {
  final double totalExpense;
  final double totalIncome;
  final double remainingBalance;

  final int totalTransactions;

  final int totalExpenseTransactions;
  final int totalIncomeTransactions;

  final DateTime updatedAt;

  MainSummaryModel({
    required this.totalExpense,
    required this.totalIncome,
    required this.remainingBalance,
    required this.totalTransactions,
    required this.totalExpenseTransactions,
    required this.totalIncomeTransactions,
    required this.updatedAt,
  });
}