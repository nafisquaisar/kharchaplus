import 'package:cloud_firestore/cloud_firestore.dart';


class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final int items;
  final String status;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.items,
    required this.status,
  });

  factory ExpenseModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      items: data['items'] ?? 0,
      status: data['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "amount": amount,
      "items": items,
      "status": status,
      "createdAt": Timestamp.now(),
    };
  }
}
