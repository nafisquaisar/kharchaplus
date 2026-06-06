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
    debugPrint('[ExpenseDetailScreen] initState cardId=${widget.cardId}');
    Future.microtask(() {
      debugPrint('[ExpenseDetailScreen] listenExpensesByCard(${widget.cardId})');
      context.read<ExpenseViewModel>().listenExpensesByCard(widget.cardId);
    });
  }

  @override
  void didUpdateWidget(covariant ExpenseDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cardId != widget.cardId) {
      debugPrint(
        '[ExpenseDetailScreen] didUpdateWidget oldCardId=${oldWidget.cardId} newCardId=${widget.cardId}',
      );
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
    final colorScheme = Theme.of(context).colorScheme;
    final cardVM = context.watch<ExpenseCardViewModel>();
    final media = MediaQuery.of(context);
    final horizontalPadding =
        (media.size.width * 0.05).clamp(16.0, 24.0).toDouble();
    final bottomPadding = media.padding.bottom + 24;

    ExpenseCardModel? selectedCard;

    try {
      selectedCard = cardVM.cards.firstWhere((e) => e.id == widget.cardId);
    } catch (_) {}

    if (selectedCard == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

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

      body: SafeArea(
        top: false,
        bottom: false,
        child: Consumer2<ExpenseViewModel, ExpenseFilterViewModel>(
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

              backgroundColor: colorScheme.surface,

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

                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  12,
                  horizontalPadding,
                  bottomPadding,
                ),

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
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String cardId;

  const _ErrorView({required this.cardId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final error = context.watch<ExpenseViewModel>().error;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),

        child: Column(
          children: [
            Icon(
              Icons.error_outline_rounded,

              size: 64,

              color: colorScheme.error,
            ),

            const SizedBox(height: 14),

            Text(
              error ?? "Something went wrong",

              style: textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 90),

        child: Column(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 70,
              color: colorScheme.onSurfaceVariant,
            ),

            const SizedBox(height: 14),

            Text(
              "No Transactions Yet",

              style: textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Add your first expense to start tracking",

              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),

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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottomInset),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: DraggableScrollableSheet(
        initialChildSize: 0.82,
        minChildSize: 0.60,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return SafeArea(
            top: false,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
      ),
    );
  }
}
