import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ExpenseModel.dart';
import '../model/ExpenseCardModel.dart';

class ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ➕ Add Expense + Update Card
  Future<void> addExpense(ExpenseModel expense) async {
    final expenseRef = _firestore
        .collection("users")
        .doc(expense.userId)
        .collection("expenses")
        .doc(expense.id);

    final cardRef = _firestore
        .collection("users")
        .doc(expense.userId)
        .collection("expense_cards")
        .doc(expense.cardId);

    await _firestore.runTransaction((tx) async {
      tx.set(expenseRef, expense.toJson());

      final cardSnap = await tx.get(cardRef);
      if (!cardSnap.exists) return;

      final card = ExpenseCardModel.fromJson(cardSnap.data()!);

      final updatedCard = card.copyWith(
        totalAmount: card.totalAmount + expense.amount,
        totalItems: card.totalItems + 1,
        updatedAt: DateTime.now(),
      );

      tx.update(cardRef, updatedCard.toJson());
    });
  }

  // 📥 Get ALL Expenses (one-time fetch)
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .get();

    return snapshot.docs.map((doc) {
      return ExpenseModel.fromJson(doc.data());
    }).toList();
  }

  // 📥 Stream by cardId
  Stream<List<ExpenseModel>> getExpensesByCard(String userId, String cardId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .where("cardId", isEqualTo: cardId)
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ExpenseModel.fromJson(doc.data());
          }).toList();
        });
  }

  // ❌ Delete Expense + Update Card
  Future<void> deleteExpense(ExpenseModel expense) async {
    final expenseRef = _firestore
        .collection("users")
        .doc(expense.userId)
        .collection("expenses")
        .doc(expense.id);

    final cardRef = _firestore
        .collection("users")
        .doc(expense.userId)
        .collection("expense_cards")
        .doc(expense.cardId);

    await _firestore.runTransaction((tx) async {
      tx.delete(expenseRef);

      final cardSnap = await tx.get(cardRef);
      if (!cardSnap.exists) return;

      final card = ExpenseCardModel.fromJson(cardSnap.data()!);

      final updatedCard = card.copyWith(
        totalAmount: card.totalAmount - expense.amount,
        totalItems: (card.totalItems - 1).clamp(0, 9999),
        updatedAt: DateTime.now(),
      );

      tx.update(cardRef, updatedCard.toJson());
    });
  }

  // ✏️ Update Expense + Fix Card Amount
  Future<void> updateExpense(ExpenseModel expense, double oldAmount) async {
    final expenseRef = _firestore
        .collection("users")
        .doc(expense.userId)
        .collection("expenses")
        .doc(expense.id);

    final cardRef = _firestore
        .collection("users")
        .doc(expense.userId)
        .collection("expense_cards")
        .doc(expense.cardId);

    await _firestore.runTransaction((tx) async {
      tx.update(expenseRef, expense.toJson());

      final cardSnap = await tx.get(cardRef);
      if (!cardSnap.exists) return;

      final card = ExpenseCardModel.fromJson(cardSnap.data()!);

      final diff = expense.amount - oldAmount;

      final updatedCard = card.copyWith(
        totalAmount: card.totalAmount + diff,
        updatedAt: DateTime.now(),
      );

      tx.update(cardRef, updatedCard.toJson());
    });
  }

  // 🔍 Filter by Date
  Future<List<ExpenseModel>> getExpensesByDate(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final data = await getExpenses(userId);

    return data.where((e) {
      return !e.isDeleted &&
          e.date.isAfter(start.subtract(const Duration(days: 1))) &&
          e.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // 📂 Filter by Category
  Future<List<ExpenseModel>> getExpensesByCategory(
    String userId,
    String categoryId,
  ) async {
    final data = await getExpenses(userId);

    return data.where((e) {
      return !e.isDeleted && e.categoryId == categoryId;
    }).toList();
  }

  // 💳 Filter by Payment Mode
  Future<List<ExpenseModel>> getByPaymentMode(
    String userId,
    PaymentMode mode,
  ) async {
    final data = await getExpenses(userId);

    return data.where((e) {
      return !e.isDeleted && e.paymentMode == mode;
    }).toList();
  }

  // 📊 Total Expense
  Future<double> getTotalExpense(String userId) async {
    final data = await getExpenses(userId);

    return data
        .where((e) => !e.isDeleted && e.type == ExpenseType.expense)
        .fold<double>(0.0, (sum, e) => sum + e.amount);
  }


  // 💰 Total Income
  Future<double> getTotalIncome(String userId) async {
    final data = await getExpenses(userId);

    return data
        .where((e) => !e.isDeleted && e.type == ExpenseType.income)
        .fold<double>(0.0, (sum, e) => sum + e.amount);
  }

  // 🧾 Balance
  Future<double> getBalance(String userId) async {
    final income = await getTotalIncome(userId);
    final expense = await getTotalExpense(userId);
    return income - expense;
  }

  // 📈 Category-wise
  Future<Map<String, double>> getCategoryWiseExpense(String userId) async {
    final data = await getExpenses(userId);

    final Map<String, double> result = {};

    for (var e in data) {
      if (!e.isDeleted && e.type == ExpenseType.expense) {
        result[e.categoryName] = (result[e.categoryName] ?? 0) + e.amount;
      }
    }

    return result;
  }
}
