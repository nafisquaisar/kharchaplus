import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../model/ExpenseModel.dart';

class ExpenseViewModel extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<ExpenseModel> expenses = [];
  bool isLoading = false;

  String get uid => _auth.currentUser!.uid;

  /// 🔥 LISTEN REAL-TIME
  void fetchExpenses() {
    isLoading = true;
    notifyListeners();

    _firestore
        .collection('users')
        .doc(uid)
        .collection('expense_cards')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      expenses =
          snapshot.docs.map((doc) => ExpenseModel.fromDoc(doc)).toList();

      isLoading = false;
      notifyListeners();
    });
  }

  /// ➕ ADD EXPENSE CARD
  Future<void> addExpense(ExpenseModel model) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('expense_cards')
        .add(model.toMap());
  }
}