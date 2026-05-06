class ExpenseCardModel {
  final String id;
  final String userId; // 🔥 multi-user support

  final DateTime startDate;
  final DateTime endDate;

  final double totalAmount;
  final int totalItems;

  final String status; // Active / Upcoming / Completed
  final double progress; // 0 → 1

  final String title;
  final String? notes;

  final DateTime createdAt;
  final DateTime updatedAt;

  ExpenseCardModel({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.totalItems,
    required this.status,
    required this.progress,
    required this.title,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // 🔄 JSON → Object
  factory ExpenseCardModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCardModel(
      id: json['id'],
      userId: json['userId'], // 🔥 important

      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),

      totalAmount: (json['totalAmount'] as num).toDouble(),
      totalItems: json['totalItems'] ?? 0,

      status: json['status'] ?? "Active",
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,

      title: json['title'] ?? "",
      notes: json['notes'],

      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // 🔄 Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,

      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),

      'totalAmount': totalAmount,
      'totalItems': totalItems,

      'status': status,
      'progress': progress,

      'title': title,
      'notes': notes,

      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // 🔁 CopyWith (important for updates)
  ExpenseCardModel copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    double? totalAmount,
    int? totalItems,
    String? status,
    double? progress,
    String? title,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseCardModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalAmount: totalAmount ?? this.totalAmount,
      totalItems: totalItems ?? this.totalItems,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
