import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/KharchaThemeColors.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/AppFlushbar.dart';
import '../viewmodel/ExpenseCardViewModel.dart';
import '../widgets/ExpensePage/expense_card.dart';
import '../widgets/ExpensePage/expense_search_bar.dart';
import '../bottomsheet/create_expense_card_sheet.dart';
import 'expense_detail_screen.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  Map<String, dynamic>? _lastDeleted;

  String searchQuery = "";
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    Future.microtask(() {
      context.read<ExpenseCardViewModel>().listenCards(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpenseCardViewModel>();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final filteredCards = vm.cards.where((card) {
      return card.title.toLowerCase().contains(searchQuery) ||
          card.notes!.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [


          /// 🔥 SEARCH BAR
          ExpenseSearchBar(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),

          const SizedBox(height: 16),

          /// 🔥 EMPTY STATE
          if (filteredCards.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text("No expenses found"),
              ),
            ),

          ...filteredCards.map((card) {
            final subtitle =
                "${DateFormat('d MMM').format(card.startDate)} - ${DateFormat('d MMM').format(card.endDate)}";

            return Dismissible(
              key: ValueKey(card.id),

              background: swipeBackground(
                color: Colors.blue,
                icon: Icons.edit,
                alignment: Alignment.centerLeft,
              ),

              secondaryBackground: swipeBackground(
                color: Colors.red,
                icon: Icons.delete,
                alignment: Alignment.centerRight,
              ),

              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => CreateExpenseCardSheet(card: card),
                  );

                  if (result != null && mounted) {
                    showSnack(result);
                  }

                  return false;
                } else {
                  return await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete"),
                      content: const Text("Are you sure?"),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                }
              },

              onDismissed: (_) {
                _lastDeleted = {
                  "card": card,
                  "index": vm.cards.indexOf(card),
                };

                vm.deleteCard(userId, card.id);
                showUndoFlushbar();
              },

              child: ExpenseCard(
                title: card.title,
                subtitle: subtitle,
                amount: card.totalAmount.toStringAsFixed(0),
                items: "${card.totalItems} Items",
                status: card.status,
                progress: card.progress,
                isHighlighted: card.status == "Active",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExpenseDetailScreen(),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () async {
          final result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const CreateExpenseCardSheet(),
          );

          if (result != null && mounted) {
            showSnack(result);
          }
        },
        child: const Icon(Icons.add, color: AppColors.textPrimary),
      ),
    );
  }

  void showSnack(String type) {
    if (type == "updated") {
      AppFlushbar.showSuccess(context, "Expense updated");
    } else if (type == "created") {
      AppFlushbar.showSuccess(context, "Expense created");
    } else {
      AppFlushbar.showInfo(context, "Expense deleted");
    }
  }

  void showUndoFlushbar() {
    AppFlushbar.showUndo(
      context,
      message: "Expense deleted",
      onUndo: () async {
        if (_lastDeleted == null) return;

        final card = _lastDeleted!["card"];
        await context.read<ExpenseCardViewModel>().addCard(card);

        _lastDeleted = null;
      },
    );
  }

  Widget swipeBackground({
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color),
    );
  }
}