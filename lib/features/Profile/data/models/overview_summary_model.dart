/// Overview Summary Model - Holds aggregated data for the monthly overview dashboard
/// Supports null-safety and immutability
class OverviewSummaryModel {
  final String id;
  final String userId;
  final String month; // Format: "YYYY-MM"

  // Financial metrics
  final double totalExpense;
  final double totalIncome;
  final double balance;

  // Tracking metrics
  final double waterIntakeLiters;
  final double electricityUnits;

  // Trend data (percentage change from previous month)
  final double expenseTrend; // positive = increased spending
  final double incomeTrend;  // positive = increased income
  final double waterTrend;   // positive = more consumption
  final double electricityTrend; // positive = more units

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;

  const OverviewSummaryModel({
    required this.id,
    required this.userId,
    required this.month,
    required this.totalExpense,
    required this.totalIncome,
    required this.balance,
    required this.waterIntakeLiters,
    required this.electricityUnits,
    this.expenseTrend = 0.0,
    this.incomeTrend = 0.0,
    this.waterTrend = 0.0,
    this.electricityTrend = 0.0,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
  });

  /// Copy with method for immutability
  OverviewSummaryModel copyWith({
    String? id,
    String? userId,
    String? month,
    double? totalExpense,
    double? totalIncome,
    double? balance,
    double? waterIntakeLiters,
    double? electricityUnits,
    double? expenseTrend,
    double? incomeTrend,
    double? waterTrend,
    double? electricityTrend,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return OverviewSummaryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      month: month ?? this.month,
      totalExpense: totalExpense ?? this.totalExpense,
      totalIncome: totalIncome ?? this.totalIncome,
      balance: balance ?? this.balance,
      waterIntakeLiters: waterIntakeLiters ?? this.waterIntakeLiters,
      electricityUnits: electricityUnits ?? this.electricityUnits,
      expenseTrend: expenseTrend ?? this.expenseTrend,
      incomeTrend: incomeTrend ?? this.incomeTrend,
      waterTrend: waterTrend ?? this.waterTrend,
      electricityTrend: electricityTrend ?? this.electricityTrend,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  /// Convert to JSON for Firestore storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'month': month,
      'totalExpense': totalExpense,
      'totalIncome': totalIncome,
      'balance': balance,
      'waterIntakeLiters': waterIntakeLiters,
      'electricityUnits': electricityUnits,
      'expenseTrend': expenseTrend,
      'incomeTrend': incomeTrend,
      'waterTrend': waterTrend,
      'electricityTrend': electricityTrend,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isArchived': isArchived,
    };
  }

  /// Create from JSON (from Firestore)
  factory OverviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return OverviewSummaryModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      month: json['month'] ?? '',
      totalExpense: (json['totalExpense'] ?? 0.0).toDouble(),
      totalIncome: (json['totalIncome'] ?? 0.0).toDouble(),
      balance: (json['balance'] ?? 0.0).toDouble(),
      waterIntakeLiters: (json['waterIntakeLiters'] ?? 0.0).toDouble(),
      electricityUnits: (json['electricityUnits'] ?? 0.0).toDouble(),
      expenseTrend: (json['expenseTrend'] ?? 0.0).toDouble(),
      incomeTrend: (json['incomeTrend'] ?? 0.0).toDouble(),
      waterTrend: (json['waterTrend'] ?? 0.0).toDouble(),
      electricityTrend: (json['electricityTrend'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      isArchived: json['isArchived'] ?? false,
    );
  }

  /// Create empty/placeholder model
  factory OverviewSummaryModel.empty({
    required String userId,
    required String month,
  }) {
    return OverviewSummaryModel(
      id: 'overview_$month',
      userId: userId,
      month: month,
      totalExpense: 0.0,
      totalIncome: 0.0,
      balance: 0.0,
      waterIntakeLiters: 0.0,
      electricityUnits: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'OverviewSummaryModel(id: $id, userId: $userId, month: $month, '
        'expense: $totalExpense, income: $totalIncome, water: $waterIntakeLiters, '
        'electricity: $electricityUnits)';
  }
}

