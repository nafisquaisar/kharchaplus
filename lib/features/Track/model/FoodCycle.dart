class FoodCycle {
  final String id;
  final double price;
  final DateTime startDate;
  final DateTime? endDate;
  final String sundayRule;
  final String status;

  FoodCycle({
    required this.id,
    required this.price,
    required this.startDate,
    this.endDate,
    required this.sundayRule,
    this.status = "Active",
  });

  // 🔥 Dynamic title
  String get title {
    final start = "${startDate.day} ${_month(startDate.month)}";
    final end = endDate != null
        ? "${endDate!.day} ${_month(endDate!.month)}"
        : "";
    return "$start - $end";
  }

  String _month(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }
}