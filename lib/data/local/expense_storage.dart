import 'package:hive/hive.dart';
import '../model/expense_model.dart';

class ExpenseStorage {
  final Box<Expense> _box = Hive.box<Expense>('expenses');

  List<Expense> getExpenses() {
    return _box.values.toList().reversed.toList();
  }

  void addExpense(Expense expense) {
    _box.put(expense.id, expense);
  }

  Expense? getById(String id) {
    return _box.get(id);
  }

  void updateExpense(Expense expense) {
    _box.put(expense.id, expense);
  }

  void deleteExpense(String id) {
    _box.delete(id);
  }
}