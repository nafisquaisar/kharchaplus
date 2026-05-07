class ExpenseCardModel {
  final String id;

  final String userId;

  /// =====================================================
  /// CARD DATES
  /// =====================================================

  final DateTime startDate;

  final DateTime endDate;

  /// =====================================================
  /// SUMMARY
  /// =====================================================

  final double totalBudget;

  final double totalExpense;

  final double remainingAmount;

  final int totalItems;

  /// =====================================================
  /// STATUS
  /// =====================================================

  final String status;

  final double progress;

  /// =====================================================
  /// UI DATA
  /// =====================================================

  final String title;

  final String? notes;

  /// =====================================================
  /// SOFT DELETE
  /// =====================================================

  final bool isDeleted;

  /// =====================================================
  /// TIMESTAMPS
  /// =====================================================

  final DateTime createdAt;

  final DateTime updatedAt;

  const ExpenseCardModel({
    required this.id,

    required this.userId,

    required this.startDate,

    required this.endDate,

    required this.totalBudget,
    required this.totalExpense,
    required this.remainingAmount,

    required this.totalItems,

    required this.status,

    required this.progress,

    required this.title,

    this.notes,

    this.isDeleted = false,

    required this.createdAt,

    required this.updatedAt,
  });

  /// =====================================================
  /// FROM JSON
  /// =====================================================

  factory ExpenseCardModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCardModel(
      id: json['id'] ?? "",

      userId: json['userId'] ?? "",

      startDate: DateTime.parse(json['startDate']),

      endDate: DateTime.parse(json['endDate']),

      totalBudget: (json['totalBudget'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0.0,
      remainingAmount: (json['remainingAmount'] as num?)?.toDouble() ?? 0.0,

      totalItems: json['totalItems'] ?? 0,

      status: json['status'] ?? "Active",

      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,

      title: json['title'] ?? "",

      notes: json['notes'],

      /// ✅ IMPORTANT
      isDeleted: json['isDeleted'] ?? false,

      createdAt: DateTime.parse(json['createdAt']),

      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// =====================================================
  /// TO JSON
  /// =====================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'userId': userId,

      'startDate': startDate.toIso8601String(),

      'endDate': endDate.toIso8601String(),

      'totalBudget': totalBudget,
      'totalExpense': totalExpense,

      'remainingAmount': remainingAmount,

      'totalItems': totalItems,

      'status': status,

      'progress': progress,

      'title': title,

      'notes': notes,

      /// ✅ IMPORTANT
      'isDeleted': isDeleted,

      'createdAt': createdAt.toIso8601String(),

      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// =====================================================
  /// COPY WITH
  /// =====================================================

  ExpenseCardModel copyWith({
    String? id,

    String? userId,

    DateTime? startDate,

    DateTime? endDate,

    double? totalExpense,
    double? totalBudget,
    double? remainingAmount,

    int? totalItems,

    String? status,

    double? progress,

    String? title,

    String? notes,

    bool? isDeleted,

    DateTime? createdAt,

    DateTime? updatedAt,
  }) {
    return ExpenseCardModel(
      id: id ?? this.id,

      userId: userId ?? this.userId,

      startDate: startDate ?? this.startDate,

      endDate: endDate ?? this.endDate,

      totalExpense: totalExpense ?? this.totalExpense,
      totalBudget: totalBudget ?? this.totalBudget,
      remainingAmount: remainingAmount ?? this.remainingAmount,

      totalItems: totalItems ?? this.totalItems,

      status: status ?? this.status,

      progress: progress ?? this.progress,

      title: title ?? this.title,

      notes: notes ?? this.notes,

      isDeleted: isDeleted ?? this.isDeleted,

      createdAt: createdAt ?? this.createdAt,

      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
