import 'dart:convert';

enum ExpenseType { income, expense }

enum PaymentMode { cash, upi, card, netBanking }

class ExpenseModel {
  final String id;
  final String userId;

  final double amount;
  final String currency;

  final String categoryId;
  final String categoryName;
  final String cardId;

  final String? note;

  final ExpenseType type;
  final PaymentMode paymentMode;

  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? location;

  final bool isSynced;
  final bool isDeleted;

  ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.categoryId,
    required this.categoryName,
    required this.cardId,
    this.note,
    required this.type,
    required this.paymentMode,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.location,
    this.isSynced = false,
    this.isDeleted = false,
  });

  // 🔁 CopyWith (for updates)
  ExpenseModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? currency,
    String? categoryId,
    String? categoryName,
    String? note,
    ExpenseType? type,
    PaymentMode? paymentMode,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? location,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      cardId: cardId ?? cardId,
      note: note ?? this.note,
      type: type ?? this.type,
      paymentMode: paymentMode ?? this.paymentMode,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      location: location ?? this.location,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  // 🔄 JSON → Object
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      userId: json['userId'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] ?? "INR",
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      cardId: json['cardId'],
      note: json['note'],
      type: ExpenseType.values.firstWhere((e) => e.name == json['type']),
      paymentMode: PaymentMode.values.firstWhere(
            (e) => e.name == json['paymentMode'],
      ),
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      location: json['location'],
      isSynced: json['isSynced'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  // 🔄 Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'cardId': cardId,
      'note': note,
      'type': type.name,
      'paymentMode': paymentMode.name,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'location': location,
      'isSynced': isSynced,
      'isDeleted': isDeleted,
    };
  }

  // 🔁 Encode / Decode helpers
  static String encode(List<ExpenseModel> expenses) =>
      json.encode(expenses.map((e) => e.toJson()).toList());

  static List<ExpenseModel> decode(String expenses) =>
      (json.decode(expenses) as List<dynamic>)
          .map((e) => ExpenseModel.fromJson(e))
          .toList();
}
