import 'package:expense_tracker/features/Home/presentation/widgets/header/home_header.dart';
import 'package:expense_tracker/features/Home/presentation/widgets/quick_actions/quick_actions_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import '../../../Expense/data/model/ExpenseCardModel.dart';
import '../../../Expense/presentation/viewmodel/ExpenseCardViewModel.dart';
import '../../../Expense/presentation/viewmodel/expense_viewmodel.dart';

import '../../../Track/WaterTracking/presentation/providers/session/water_session_provider.dart';
import '../../../Track/WaterTracking/presentation/providers/sync/sync_provider.dart';

import '../providers/water_tracking/water_tracking_home_providers.dart';

import '../widgets/electricity_tracking/electricity_tracking_card.dart';
import '../widgets/food_tracking/food_tracking_card.dart';
import '../widgets/monthly_overview/balance_card.dart';
import '../widgets/recent_activity/recent_activity_section.dart';
import '../widgets/water_tracking/water_tracking_card.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
  });

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final ValueNotifier<ExpenseCardModel?> selectedCardNotifier =
      ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    /// ✅ Initialize once
    ref.read(
      waterSessionControllerProvider,
    );

    ref.read(
      waterSyncNotifierProvider,
    );

    ref.read(
      waterTrackingHomeNotifierProvider,
    );

    debugPrint(
      '[HomeScreen] water home providers initialized',
    );

    /// ✅ Production-level auto select
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final cardVm = context.read<ExpenseCardViewModel>();

        cardVm.addListener(
          _handleInitialCardSelection,
        );

        /// ✅ Handle already-loaded state
        _handleInitialCardSelection();
      },
    );
  }

  /// ✅ Auto select latest card
  void _handleInitialCardSelection() {
    final cardVm = context.read<ExpenseCardViewModel>();

    if (selectedCardNotifier.value != null || cardVm.cards.isEmpty) {
      return;
    }

    final latestCard = [...cardVm.cards]..sort(
        (
          a,
          b,
        ) {
          final aDate = a.startDate ?? DateTime(2000);

          final bDate = b.startDate ?? DateTime(2000);

          return bDate.compareTo(
            aDate,
          );
        },
      );

    selectedCardNotifier.value = latestCard.first;

    context.read<ExpenseViewModel>().listenExpensesByCard(
          latestCard.first.id,
        );
  }

  @override
  void dispose() {
    context.read<ExpenseCardViewModel>().removeListener(
          _handleInitialCardSelection,
        );

    selectedCardNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final horizontalPadding =
        (media.size.width * 0.01).clamp(2.0, 4.0).toDouble();
    final bottomSpacing =
        (media.padding.bottom + kBottomNavigationBarHeight + 24)
            .clamp(80.0, 140.0)
            .toDouble();

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          key: const PageStorageKey(
            'home_scroll',
          ),
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// ✅ Production-Level Lazy Rendering
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const _DashboardSpacing(),

                    /// ✅ HEADER
                    Selector<ExpenseCardViewModel, ExpenseCardViewModel>(
                      selector: (
                        _,
                        vm,
                      ) =>
                          vm,
                      builder: (
                        _,
                        cardVm,
                        __,
                      ) {
                        return ValueListenableBuilder<ExpenseCardModel?>(
                          valueListenable: selectedCardNotifier,
                          builder: (
                            _,
                            selectedCard,
                            __,
                          ) {
                            return HomeHeader(
                              selectedCard: selectedCard,
                              onCardSelected: (
                                card,
                              ) {
                                if (card == null) {
                                  return;
                                }

                                /// ✅ No full rebuild
                                selectedCardNotifier.value = card;

                                context
                                    .read<ExpenseViewModel>()
                                    .listenExpensesByCard(
                                      card.id,
                                    );
                              },
                            );
                          },
                        );
                      },
                    ),

                    const _DashboardSpacing(),

                    /// ✅ BALANCE CARD
                    ValueListenableBuilder<ExpenseCardModel?>(
                      valueListenable: selectedCardNotifier,
                      builder: (
                        _,
                        selectedCard,
                        __,
                      ) {
                        return Selector<ExpenseViewModel, ExpenseViewModel>(
                          selector: (
                            _,
                            vm,
                          ) =>
                              vm,
                          builder: (
                            _,
                            expenseVm,
                            __,
                          ) {
                            return RepaintBoundary(
                              child: BalanceCard(
                                selectedCard: selectedCard,
                                expenseVm: expenseVm,
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const _DashboardSpacing(),

                    /// ✅ RECENT ACTIVITY
                    const RepaintBoundary(
                      child: RecentActivitySection(),
                    ),

                    const _DashboardSpacing(),

                    /// ✅ FOOD TRACKING
                    const RepaintBoundary(
                      child: FoodTrackingCard(),
                    ),

                    const _DashboardSpacing(),

                    /// ✅ ELECTRICITY TRACKING
                    const RepaintBoundary(
                      child: ElectricityTrackingCard(),
                    ),

                    const _DashboardSpacing(),

                    /// ✅ WATER TRACKING
                    const RepaintBoundary(
                      child: WaterTrackingCard(),
                    ),

                    const _DashboardSpacing(),

                    /// ✅ QUICK ACTIONS
                    const RepaintBoundary(
                      child: QuickActionsSection(),
                    ),

                    SizedBox(
                      height: bottomSpacing,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Reusable spacing widget
class _DashboardSpacing extends StatelessWidget {
  const _DashboardSpacing();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
    );
  }
}
