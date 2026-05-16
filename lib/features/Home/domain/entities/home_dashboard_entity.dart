class HomeDashboardEntity {
  final double balance;
  final double income;
  final double expense;
  final int totalTransactions;
  final DateTime? selectedDate;

  const HomeDashboardEntity({
    required this.balance,
    required this.income,
    required this.expense,
    required this.totalTransactions,
    required this.selectedDate,
  });
}