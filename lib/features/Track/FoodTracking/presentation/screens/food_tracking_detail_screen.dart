import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../../core/Common/CommonAppBar.dart';

import '../../domain/entities/FoodCycle.dart';

import '../viewmodel/meal_entry_viewmodel.dart';

import '../widgets/food_tracking_detail_widgets/calendar_widget.dart';

import '../widgets/food_tracking_detail_widgets/meal_selector.dart';

import '../widgets/food_tracking_detail_widgets/summary_row.dart';

class FoodTrackingDetailScreen extends StatefulWidget {
  final FoodCycle cycle;

  const FoodTrackingDetailScreen({super.key, required this.cycle});

  @override
  State<FoodTrackingDetailScreen> createState() =>
      _FoodTrackingDetailScreenState();
}

class _FoodTrackingDetailScreenState extends State<FoodTrackingDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealEntryViewModel>().initialize(widget.cycle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MealEntryViewModel>(
      builder: (_, vm, __) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),

            child: CommonAppBar(
              title: vm.cycleTitle,

              isHome: false,

              isDashboard: false,

              showMore: true,

              onMenuTap: () {
                Navigator.pop(context);
              },

              onNotificationTap: () {},

              onMoreTap: () {},
            ),
          ),

          body: SafeArea(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Text(
                        vm.error!,

                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          fontSize: 14,

                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),

                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,

                    child: Column(
                      children: [
                        // =========================
                        // SUMMARY
                        // =========================
                        Padding(
                          padding: const EdgeInsets.only(top: 8),

                          child: SummaryRow(
                            totalMeals: vm.totalMeals,

                            lunch: vm.lunchCount,

                            dinner: vm.dinnerCount,

                            remaining: vm.remainingMeals,

                            cost: vm.totalCost,

                            totalTiffin: widget.cycle.totalTiffin,
                          ),
                        ),

                        // =========================
                        // CALENDAR
                        // =========================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),

                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.55,

                            child: CalendarWidget(
                              mealData: vm.calendarData,

                              selectedDate: vm.selectedDate,

                              cycleStartDate: widget.cycle.startDate,

                              cycleEndDate: widget.cycle.endDate,

                              onDateTap: vm.selectDate,
                            ),
                          ),
                        ),

                        // =========================
                        // MEAL SELECTOR
                        // =========================
                        MealSelector(
                          date: vm.selectedDate,

                          data: vm.calendarData,

                          sundayRule: widget.cycle.sundayRule.name,

                          onToggle: (key, type) {
                            vm.toggleMeal(
                              context: context,

                              cycleId: widget.cycle.id,

                              date: vm.selectedDate,

                              type: type,
                            );
                          },
                        ),

                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
