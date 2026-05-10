import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/Common/CommonAppBar.dart';
import '../../../../core/constants/AppColors.dart';

import '../../data/model/ExpenseCardModel.dart';

import '../../utils/expense_detail_helper.dart';
import '../../utils/expense_shimmer.dart';
import '../bottomsheet/AddExpenseSheet/add_expense_sheet.dart';

import '../viewmodel/ExpenseCardViewModel.dart';
import '../viewmodel/ExpenseFilterViewModel.dart';
import '../viewmodel/expense_viewmodel.dart';

import '../widgets/ExpenseDetail/filter_row.dart';
import '../widgets/ExpenseDetail/summary_card.dart';
import '../widgets/ExpenseDetail/transaction_list.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final String cardId;

  const ExpenseDetailScreen({super.key, required this.cardId});

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ExpenseViewModel>().listenExpensesByCard(widget.cardId);
    });
  }

  @override
  void didUpdateWidget(covariant ExpenseDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cardId != widget.cardId) {
      context.read<ExpenseViewModel>().listenExpensesByCard(widget.cardId);
    }
  }

  Future<void> openSheet() async {
    await showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (_) {
        return _AddExpenseWrapper(cardId: widget.cardId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardVM = context.watch<ExpenseCardViewModel>();

    ExpenseCardModel? selectedCard;

    try {
      selectedCard = cardVM.cards.firstWhere((e) => e.id == widget.cardId);
    } catch (_) {}

    if (selectedCard == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),

        child: CommonAppBar(
          title: selectedCard.title,

          isHome: false,

          hasNotification: false,

          onMenuTap: () {
            Navigator.pop(context);
          },

          onNotificationTap: () {},
        ),
      ),

      body: Consumer2<ExpenseViewModel, ExpenseFilterViewModel>(
        builder: (_, expenseVM, filterVM, __) {
          final filteredExpenses = filterVM.filterExpenses(expenseVM.expenses);

          final totalExpense = ExpenseDetailHelper.calculateExpense(
            filteredExpenses,
          );

          final totalIncome = ExpenseDetailHelper.calculateIncome(
            filteredExpenses,
          );

          final balance = ExpenseDetailHelper.calculateBalance(
            income: totalIncome,

            expense: totalExpense,
          );

          final recentCompletedCard =
              ExpenseDetailHelper.getRecentCompletedCard(
                cards: cardVM.cards,

                currentCardId: widget.cardId,
              );

          return RefreshIndicator(
            /// 🔥 FIXED PULL REFRESH
            displacement: 40,

            edgeOffset: 20,

            color: AppColors.accent,

            backgroundColor: Colors.white,

            onRefresh: () {
              return ExpenseDetailHelper.refreshExpenses(
                context: context,

                cardId: widget.cardId,
              );
            },

            child: ListView(
              /// 🔥 IMPORTANT FIX
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),

              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

              children: [
                /// SUMMARY
                SummaryCard(
                  startDate: ExpenseDetailHelper.formatDate(
                    selectedCard!.startDate,
                  ),

                  endDate: ExpenseDetailHelper.formatDate(selectedCard.endDate),

                  totalExpense: totalExpense,

                  totalIncome: totalIncome,

                  balance: balance,

                  trendText: ExpenseDetailHelper.generateCardTrend(
                    currentAmount: selectedCard.totalExpense,

                    previousAmount: recentCompletedCard?.totalExpense ?? 0,
                  ),
                ),

                const SizedBox(height: 20),

                /// FILTER
                FilterRow(
                  selectedType: filterVM.selectedType,

                  onChanged: (type) {
                    filterVM.setQuickFilter(type);
                  },

                  onFilterTap: () {
                    ExpenseDetailHelper.openFilterSheet(
                      context: context,

                      filterVM: filterVM,
                    );
                  },

                  onAddTap: openSheet,
                ),

                const SizedBox(height: 14),

                /// LOADING
                if (expenseVM.isInitialLoading) const ExpenseShimmer(),

                /// ERROR
                if (!expenseVM.isInitialLoading && expenseVM.error != null)
                  _ErrorView(cardId: widget.cardId),

                /// EMPTY
                if (!expenseVM.isInitialLoading &&
                    expenseVM.error == null &&
                    filteredExpenses.isEmpty)
                  const _EmptyView(),

                /// LIST
                if (!expenseVM.isInitialLoading &&
                    expenseVM.error == null &&
                    filteredExpenses.isNotEmpty)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),

                    child: TransactionList(expenses: filteredExpenses),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String cardId;

  const _ErrorView({required this.cardId});

  @override
  Widget build(BuildContext context) {
    final error = context.watch<ExpenseViewModel>().error;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),

        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,

              size: 64,

              color: Colors.redAccent,
            ),

            const SizedBox(height: 14),

            Text(
              error ?? "Something went wrong",

              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: () {
                ExpenseDetailHelper.retry(context: context, cardId: cardId);
              },

              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 90),

        child: Column(
          children: [
            Icon(Icons.receipt_long_rounded, size: 70, color: Colors.grey),

            SizedBox(height: 14),

            Text(
              "No Transactions Yet",

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 8),

            Text(
              "Add your first expense to start tracking",

              style: TextStyle(color: Colors.grey),

              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddExpenseWrapper extends StatelessWidget {
  final String cardId;

  const _AddExpenseWrapper({required this.cardId});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.82,

      minChildSize: 0.60,

      maxChildSize: 0.95,

      expand: false,

      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.primarybg,

            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),

          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),

            child: SingleChildScrollView(
              controller: scrollController,

              physics: const BouncingScrollPhysics(),

              child: AddExpenseSheet(
                cardId: cardId,

                onAdd: (expense) async {
                  final expenseVM = context.read<ExpenseViewModel>();

                  await expenseVM.addExpense(expense);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
