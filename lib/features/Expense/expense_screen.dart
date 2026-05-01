import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'widgets/expense_card.dart';
import 'bottomsheet/create_expense_card_sheet.dart';
import 'ExpenseDetail/expense_detail_screen.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Your Expense Cards",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ExpenseCard(
            title: "Jan 5, 2024 - Feb 4, 2024",
            amount: "₹ 12,450",
            items: "18 Items",
            status: "Active",
            isHighlighted: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExpenseDetailScreen(),
                ),
              );
            },
          ),

          ExpenseCard(
            title: "Feb 5, 2024 - Mar 4, 2024",
            amount: "₹ 8,200",
            items: "12 Items",
            status: "Active",
          ),

          ExpenseCard(
            title: "Mar 5, 2024 - Apr 4, 2024",
            amount: "₹ 0",
            items: "",
            status: "Upcoming",
          ),
        ],
      ),

      // 🔥 FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F46E5),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const CreateExpenseCardSheet(),
          );
        },
        child: const Icon(Icons.add ,color: AppColors.textPrimary,),
      ),
    );
  }
}