import 'package:expense_tracker/features/Home/presentation/widgets/header/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/AppColors.dart';
import '../../../Expense/data/model/ExpenseCardModel.dart';
import '../../../Expense/presentation/viewmodel/ExpenseCardViewModel.dart';
import '../../../Expense/presentation/viewmodel/expense_viewmodel.dart';

import '../widgets/electricity_tracking/electricity_tracking_card.dart';
import '../widgets/food_tracking/food_tracking_card.dart';
import '../widgets/monthly_overview/balance_card.dart';
import '../widgets/quick_actions/quick_actions_section.dart';
import '../widgets/recent_activity/recent_activity_section.dart';
import '../widgets/water_tracking/water_tracking_card.dart';


class Home extends ConsumerStatefulWidget {

  const Home({super.key});

  @override
  ConsumerState<Home> createState() =>
      _HomeState();
}

class _HomeState
    extends ConsumerState<Home> {

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

      child: Container(
        color: AppColors.background,
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
                        const RecentActivitySection(),


                        const SizedBox(height: 10),
                        const FoodTrackingCard(),


                        const SizedBox(height: 10),

                        const ElectricityTrackingCard(),

                        const SizedBox(height: 10),
                        const WaterTrackingCard(),

                        // const SizedBox(height: 10),
                        // const QuickActionsSection(),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),


                ],
              ),
      ),
    );
  }
}
