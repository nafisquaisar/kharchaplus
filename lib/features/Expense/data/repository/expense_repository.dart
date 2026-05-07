import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ExpenseModel.dart';
import '../model/ExpenseCardModel.dart';

class ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> mainSummaryRef(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("summary")
        .doc("main");
  }

  DocumentReference<Map<String, dynamic>> monthlySummaryRef(
    String userId,
    String month,
  ) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("monthly_summary")
        .doc(month);
  }

  // ➕ Add Expense + Update Card
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      // =========================
      // PATHS
      // =========================

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

      final mainSummary = mainSummaryRef(expense.userId);
      final monthId = getMonthId(expense.date);

      final monthlySummary = monthlySummaryRef(expense.userId, monthId);

      // =========================
      // TRANSACTION
      // =========================

      await _firestore.runTransaction((tx) async {
        // =========================
        // ALL READS FIRST
        // =========================
        final cardSnap = await tx.get(cardRef);
        final mainSnap = await tx.get(mainSummary);
        final monthSnap = await tx.get(monthlySummary);

        // =========================
        // NOW START WRITES
        // =========================

        tx.set(expenseRef, expense.toJson());

        // =========================
        // CARD UPDATE
        // =========================

        if (cardSnap.exists) {
          final card = ExpenseCardModel.fromJson(cardSnap.data()!);

          double updatedExpense = card.totalExpense;
          double updatedIncome = card.totalIncome;
          int updatedItems = card.totalItems;
          if (expense.type == ExpenseType.expense) {
            updatedExpense += expense.amount;
          } else {
            updatedIncome += expense.amount;
          }

          updatedItems++;

          final updatedCard = card.copyWith(
            totalExpense: updatedExpense,

            totalIncome: updatedIncome,

            remainingAmount: card.totalBudget - updatedExpense,

            totalItems: updatedItems,

            updatedAt: DateTime.now(),
          );

          tx.update(cardRef, updatedCard.toJson());
        }
        // =========================
        // MAIN SUMMARY
        // =========================

        double totalExpense = 0;
        double totalIncome = 0;

        int totalTransactions = 0;

        int expenseTransactions = 0;
        int incomeTransactions = 0;

        if (mainSnap.exists) {
          final data = mainSnap.data()!;

          totalExpense = (data["totalExpense"] ?? 0).toDouble();
          totalIncome = (data["totalIncome"] ?? 0).toDouble();
          totalTransactions = data["totalTransactions"] ?? 0;
          expenseTransactions = data["totalExpenseTransactions"] ?? 0;
          incomeTransactions = data["totalIncomeTransactions"] ?? 0;
        }

        totalTransactions++;

        if (expense.type == ExpenseType.expense) {
          totalExpense += expense.amount;

          expenseTransactions++;
        } else {
          totalIncome += expense.amount;

          incomeTransactions++;
        }

        tx.set(mainSummary, {
          "totalExpense": totalExpense,

          "totalIncome": totalIncome,

          "remainingBalance": totalIncome - totalExpense,

          "totalTransactions": totalTransactions,

          "totalExpenseTransactions": expenseTransactions,

          "totalIncomeTransactions": incomeTransactions,

          "updatedAt": DateTime.now(),
        });

        // =========================
        // MONTHLY SUMMARY
        // =========================

        double monthExpense = 0;
        double monthIncome = 0;

        int monthTransactions = 0;

        int monthExpenseTransactions = 0;
        int monthIncomeTransactions = 0;

        if (monthSnap.exists) {
          final data = monthSnap.data()!;

          monthExpense = (data["totalExpense"] ?? 0).toDouble();
          monthIncome = (data["totalIncome"] ?? 0).toDouble();
          monthTransactions = data["totalTransactions"] ?? 0;
          monthExpenseTransactions = data["totalExpenseTransactions"] ?? 0;
          monthIncomeTransactions = data["totalIncomeTransactions"] ?? 0;
        }

        monthTransactions++;

        if (expense.type == ExpenseType.expense) {
          monthExpense += expense.amount;
          monthExpenseTransactions++;
        } else {
          monthIncome += expense.amount;
          monthIncomeTransactions++;
        }

        tx.set(monthlySummary, {
          "month": monthId,

          "totalExpense": monthExpense,

          "totalIncome": monthIncome,

          "remainingBalance": monthIncome - monthExpense,

          "totalTransactions": monthTransactions,

          "totalExpenseTransactions": monthExpenseTransactions,

          "totalIncomeTransactions": monthIncomeTransactions,

          "updatedAt": DateTime.now(),

          "createdAt": DateTime.now(),
        });
      });

      // =========================
      // VERIFY
      // =========================
    } catch (e, stack) {
      print(e);
      print(stack);
      rethrow;
    }
  }

  String getMonthId(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  // 📥 Get ALL Expenses (one-time fetch)
  Stream<List<ExpenseModel>> streamExpenses(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) {
                return ExpenseModel.fromJson(doc.data());
              })
              .where((expense) {
                return !expense.isDeleted;
              })
              .toList();
        });
  }

  // 📥 Stream by cardId
  Stream<List<ExpenseModel>> getExpensesByCard(String userId, String cardId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .where("cardId", isEqualTo: cardId)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) {
          final expenses =
              snapshot.docs
                  .map((doc) {
                    return ExpenseModel.fromJson(doc.data());
                  })
                  .where((expense) {
                    return !expense.isDeleted;
                  })
                  .toList()
                ..sort((a, b) => b.date.compareTo(a.date));

          print("");
          print("REALTIME COUNT => ${expenses.length}");

          return expenses;
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

    final mainSummary = mainSummaryRef(expense.userId);

    final monthId = getMonthId(expense.date);

    final monthlySummary = monthlySummaryRef(expense.userId, monthId);

    await _firestore.runTransaction((tx) async {
      // =========================
      // ALL READS FIRST
      // =========================

      final cardSnap = await tx.get(cardRef);

      final mainSnap = await tx.get(mainSummary);

      final monthSnap = await tx.get(monthlySummary);

      final now = DateTime.now();

      // =========================
      // SOFT DELETE EXPENSE
      // =========================

      tx.update(expenseRef, {"isDeleted": true, "deletedAt": now});

      // =========================
      // CARD UPDATE
      // =========================

      if (cardSnap.exists) {
        final card = ExpenseCardModel.fromJson(cardSnap.data()!);

        double updatedExpense = card.totalExpense;

        double updatedIncome = card.totalIncome;

        if (expense.type == ExpenseType.expense) {
          updatedExpense -= expense.amount;
        } else {
          updatedIncome -= expense.amount;
        }

        final updatedCard = card.copyWith(
          totalExpense: updatedExpense,

          totalIncome: updatedIncome,

          remainingAmount: card.totalBudget - updatedExpense,

          totalItems: (card.totalItems - 1).clamp(0, 999999),

          updatedAt: now,
        );

        tx.update(cardRef, updatedCard.toJson());
      }

      // =========================
      // MAIN SUMMARY REVERSE
      // =========================

      if (mainSnap.exists) {
        final data = mainSnap.data()!;

        double totalExpense = (data["totalExpense"] ?? 0).toDouble();

        double totalIncome = (data["totalIncome"] ?? 0).toDouble();

        int totalTransactions = data["totalTransactions"] ?? 0;

        int expenseTransactions = data["totalExpenseTransactions"] ?? 0;

        int incomeTransactions = data["totalIncomeTransactions"] ?? 0;

        totalTransactions--;

        if (expense.type == ExpenseType.expense) {
          totalExpense -= expense.amount;

          expenseTransactions--;
        } else {
          totalIncome -= expense.amount;

          incomeTransactions--;
        }

        tx.update(mainSummary, {
          "totalExpense": totalExpense,

          "totalIncome": totalIncome,

          "remainingBalance": totalIncome - totalExpense,

          "totalTransactions": totalTransactions.clamp(0, 999999),

          "totalExpenseTransactions": expenseTransactions.clamp(0, 999999),

          "totalIncomeTransactions": incomeTransactions.clamp(0, 999999),

          "updatedAt": now,
        });
      }

      // =========================
      // MONTHLY SUMMARY REVERSE
      // =========================

      if (monthSnap.exists) {
        final data = monthSnap.data()!;

        double monthExpense = (data["totalExpense"] ?? 0).toDouble();

        double monthIncome = (data["totalIncome"] ?? 0).toDouble();

        int monthTransactions = data["totalTransactions"] ?? 0;

        int monthExpenseTransactions = data["totalExpenseTransactions"] ?? 0;

        int monthIncomeTransactions = data["totalIncomeTransactions"] ?? 0;

        monthTransactions--;

        if (expense.type == ExpenseType.expense) {
          monthExpense -= expense.amount;

          monthExpenseTransactions--;
        } else {
          monthIncome -= expense.amount;

          monthIncomeTransactions--;
        }

        tx.update(monthlySummary, {
          "totalExpense": monthExpense,

          "totalIncome": monthIncome,

          "remainingBalance": monthIncome - monthExpense,

          "totalTransactions": monthTransactions.clamp(0, 999999),

          "totalExpenseTransactions": monthExpenseTransactions.clamp(0, 999999),

          "totalIncomeTransactions": monthIncomeTransactions.clamp(0, 999999),

          "updatedAt": now,
        });
      }
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
      final cardSnap = await tx.get(cardRef);

      tx.update(expenseRef, expense.toJson());

      if (!cardSnap.exists) {
        return;
      }

      final card = ExpenseCardModel.fromJson(cardSnap.data()!);
      final diff = expense.amount - oldAmount;
      double updatedExpense = card.totalExpense;
      double updatedIncome = card.totalIncome;
      if (expense.type == ExpenseType.expense) {
        updatedExpense += diff;
      } else {
        updatedIncome += diff;
      }

      final updatedCard = card.copyWith(
        totalExpense: updatedExpense,

        totalIncome: updatedIncome,

        remainingAmount: card.totalBudget - updatedExpense,

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

  Future<List<ExpenseModel>> getExpenses(String userId) async {
    final snapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .orderBy("date", descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return ExpenseModel.fromJson(doc.data());
    }).toList();
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
