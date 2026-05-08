import 'package:expense_tracker/features/Home/widgets/homeheader/home_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Expense/data/model/ExpenseCardModel.dart';
import '../Expense/presentation/viewmodel/ExpenseCardViewModel.dart';
import '../Expense/presentation/viewmodel/expense_viewmodel.dart';

import 'widgets/balance_card.dart';
import 'widgets/overview_header.dart';
import 'widgets/overview_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ExpenseCardModel? selectedCard;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardId = selectedCard?.id;

      if (cardId != null) {
        context.read<ExpenseViewModel>().listenExpensesByCard(cardId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardVm = context.watch<ExpenseCardViewModel>();

    final expenseVm = context.watch<ExpenseViewModel>();

    /// AUTO SELECT FIRST CARD
    if (selectedCard == null && cardVm.cards.isNotEmpty) {
      selectedCard = cardVm.cards.first;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ExpenseViewModel>().listenExpensesByCard(selectedCard!.id);
      });
    }

    return SafeArea(
      bottom: false,

      child: cardVm.isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),

              slivers: [
                /// HEADER
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      HomeHeader(
                        selectedCard: selectedCard,

                        onCardSelected: (card) {
                          if (card == null) {
                            return;
                          }

                          setState(() {
                            selectedCard = card;
                          });

                          context.read<ExpenseViewModel>().listenExpensesByCard(
                            card.id,
                          );
                        },
                      ),

                      /// BALANCE
                      BalanceCard(
                        selectedCard: selectedCard,

                        expenseVm: expenseVm,
                      ),

                      const SizedBox(height: 10),

                      const OverviewHeader(),
                    ],
                  ),
                ),

                /// LIST
                SliverFillRemaining(child: OverviewList()),
              ],
            ),
    );
  }
}
