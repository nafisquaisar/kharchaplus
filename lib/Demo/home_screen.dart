import 'package:expense_tracker/Demo/viewmodel/expense_viewmodel.dart';
import 'package:expense_tracker/Demo/widgets/add_expense_dialog.dart';
import 'package:expense_tracker/Demo/widgets/custom_appbar.dart';
import 'package:expense_tracker/Demo/widgets/expense_list.dart';
import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import '../core/constants/filter_type.dart';
import '../core/utils/formatters.dart';
import '../data/local/expense_storage.dart';
import '../data/model/expense_model.dart';


// Referenced from your file :contentReference[oaicite:0]{index=0}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ExpenseViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ExpenseViewModel(ExpenseStorage());
  }

  void _showAddExpenseDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => AddExpenseDialog(
        onSubmit: (title, amount, date) {
          setState(() {
            _viewModel.addExpense(
              title: title,
              amount: amount,
              date: date,
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(onAddPressed: _showAddExpenseDialog),

      body: SafeArea(
        child: Column(
          children: [
            // 🔥 TOTAL CARD (Improved UI)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.totalContainerStart,
                    AppColors.totalContainerEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Expense",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppFormatters.inr(_viewModel.totalExpense),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 🔥 FILTER CHIPS (Styled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  ...FilterType.values.map((filter) {
                    final isSelected =
                        _viewModel.selectedFilter == filter;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(filter.name.toUpperCase()),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.card,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                        onSelected: (_) {
                          setState(() {
                            _viewModel.setFilter(filter);
                          });
                        },
                      ),
                    );
                  }),

                  // 🔥 CUSTOM DATE BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                      onPressed: () async {
                        final range = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );

                        if (range != null) {
                          setState(() {
                            _viewModel.setCustomRange(
                                range.start, range.end);
                          });
                        }
                      },
                      child: const Text("Custom"),
                    ),
                  ),
                ],
              ),
            ),

            // 🔥 EXPENSE LIST
            Expanded(
              child: ExpenseList(
                expenses: _viewModel.filteredExpenses,
                onDelete: (id) {
                  final removed = _viewModel.removeExpense(id);

                  setState(() {});

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.card,
                      content: Text(
                        'Expense deleted',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      action: SnackBarAction(
                        label: 'Undo',
                        textColor: AppColors.primary,
                        onPressed: () {
                          if (removed != null) {
                            setState(() {
                              _viewModel.addExpense(
                                title: removed.title,
                                amount: removed.amount,
                                date: removed.date,
                              );
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
                onEdit: _showEditDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Expense expense) {
    showDialog(
      context: context,
      builder: (_) => AddExpenseDialog(
        initialExpense: expense,
        onSubmit: (title, amount, date) {
          setState(() {
            _viewModel.updateExpense(
              id: expense.id,
              title: title,
              amount: amount,
              date: date,
            );
          });
        },
      ),
    );
  }
}