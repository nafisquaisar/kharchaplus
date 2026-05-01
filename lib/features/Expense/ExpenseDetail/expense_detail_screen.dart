import 'package:flutter/material.dart';
import 'bottomsheet/add_expense_sheet.dart';
import 'widgets/expense_list_item.dart';
import 'widgets/expense_summary_card.dart';
import 'widgets/date_info_card.dart';

class ExpenseDetailScreen extends StatefulWidget {
  const ExpenseDetailScreen({super.key});

  @override
  State<ExpenseDetailScreen> createState() =>
      _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  List<Map<String, String>> expenses = [
    {"title": "Food", "amount": "₹650", "date": "22 Jan 2024"},
    {"title": "Rent", "amount": "₹5000", "date": "21 Jan 2024"},
  ];

  void addExpense(String title, String amount, String date) {
    setState(() {
      expenses.add({
        "title": title,
        "amount": "₹$amount",
        "date": date,
      });
    });
  }

  void openSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddExpenseSheet(onAdd: addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),

      appBar: AppBar(
        title: const Text("Jan 5 - Feb 4"),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          const ExpenseSummaryCard(),

          const SizedBox(height: 14),

          Row(
            children: const [
              Expanded(child: DateInfoCard(title: "Start Date", date: "5 Jan")),
              SizedBox(width: 10),
              Expanded(child: DateInfoCard(title: "End Date", date: "4 Feb")),
            ],
          ),

          const SizedBox(height: 18),

          /// 🔥 HEADER ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Expenses",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: openSheet,
                child: const Text(
                  "+ Add",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ...expenses.map((e) => ExpenseListItem(
            title: e["title"]!,
            amount: e["amount"]!,
            date: e["date"]!,
          )),
        ],
      ),

    );
  }
}