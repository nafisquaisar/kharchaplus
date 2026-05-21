import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/Common/CommonAppBar.dart';
import '../../../../../core/constants/AppColors.dart';
import '../../../../../core/utils/AppFlushbar.dart';

import '../../bottomsheet/create_food_cycle_sheet.dart';

import '../../domain/entities/FoodCycle.dart';
import '../../domain/enum/cycle_status.dart';

import '../providers/food_tracking_providers.dart';

import '../widgets/food_tracking_screen/empty_food_cycle.dart';
import '../widgets/food_tracking_screen/filterbottomsheet/food_filter_bottom_sheet.dart';
import '../widgets/food_tracking_screen/food_cycle_card.dart';
import '../widgets/food_tracking_screen/searchbar.dart';
import '../widgets/food_tracking_screen/loading_widget.dart';

import 'food_tracking_detail_screen.dart';

class FoodTrackingScreen extends ConsumerStatefulWidget {
  const FoodTrackingScreen({super.key});

  @override
  ConsumerState<FoodTrackingScreen> createState() => _FoodTrackingScreenState();
}

class _FoodTrackingScreenState extends ConsumerState<FoodTrackingScreen> {
  String searchQuery = "";
  String selectedStatus = "All";

  // =========================
  // UNDO DELETE
  // =========================

  FoodCycle? _lastDeletedCycle;

  final Set<String> _pendingDeleteIds = {};

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(foodCycleViewModelProvider).loadCycles();
    });
  }

  void openFilterSheet() {
    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent,

      builder: (_) {
        return FoodFilterBottomSheet(
          selectedStatus: selectedStatus,

          onApply: (value) {
            setState(() {
              selectedStatus = value;
            });
          },
        );
      },
    );
  }

  // =========================
  // CREATE SHEET
  // =========================

  void openCreateSheet() {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (_) {
        return const CreateFoodCycleSheet();
      },
    );
  }

  // =========================
  // EDIT SHEET
  // =========================

  void openEditSheet(FoodCycle cycle) {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (_) {
        return CreateFoodCycleSheet(cycle: cycle);
      },
    );
  }

  // =========================
  // OPEN DETAIL
  // =========================

  void openDetail(FoodCycle cycle) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) {
          return FoodTrackingDetailScreen(cycle: cycle);
        },
      ),
    );
  }

  // =========================
  // DELETE WITH UNDO
  // =========================

  Future<void> deleteCycleWithUndo(FoodCycle cycle) async {
    final vm = ref.read(foodCycleViewModelProvider);

    // HIDE UI

    setState(() {
      _pendingDeleteIds.add(cycle.id);
    });

    // TEMP STORE

    _lastDeletedCycle = cycle;

    // SHOW UNDO

    AppFlushbar.showUndo(
      context,

      message: "Food cycle deleted",

      onUndo: () async {
        setState(() {
          _pendingDeleteIds.remove(cycle.id);
        });

        _lastDeletedCycle = null;
      },
    );

    // WAIT

    await Future.delayed(const Duration(seconds: 5));

    // DELETE

    if (_lastDeletedCycle != null && _lastDeletedCycle!.id == cycle.id) {
      await vm.deleteCycle(cycle.id);

      _lastDeletedCycle = null;
    }
  }

  // =========================
  // DATE FORMAT
  // =========================

  String formatDateRange(FoodCycle cycle) {
    return "${cycle.startDate.day} "
        "${_month(cycle.startDate.month)}"
        " - "
        "${cycle.endDate.day} "
        "${_month(cycle.endDate.month)}";
  }

  String _month(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",

      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return months[month - 1];
  }

  // =========================
  // SWIPE BG
  // =========================

  Widget swipeBackground({
    required Color color,

    required IconData icon,

    required Alignment alignment,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      alignment: alignment,

      decoration: BoxDecoration(
        color: color.withOpacity(0.15),

        borderRadius: BorderRadius.circular(18),
      ),

      child: Icon(icon, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),

      // =========================
      // APP BAR
      // =========================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),

        child: CommonAppBar(
          title: "Food Tracking",
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

      // =========================
      // BODY
      // =========================
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,

        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },

        child: Consumer(
          builder: (context, ref, _) {
            final vm = ref.watch(foodCycleViewModelProvider);

            // =========================
            // LOADING
            // =========================

            if (vm.isLoading) {
              return const LoadingWidget();
            }

            // =========================
            // SEARCH + FILTER
            // =========================

            final filteredCycles = vm.cycles.where((cycle) {
              if (_pendingDeleteIds.contains(cycle.id)) {
                return false;
              }
              final title = cycle.title?.toLowerCase() ?? "";
              final matchesSearch = title.contains(searchQuery.toLowerCase());

              final matchesStatus =
                  selectedStatus == "All" ||
                  cycle.status.name.toLowerCase() ==
                      selectedStatus.toLowerCase();

              return matchesSearch && matchesStatus;
            }).toList();

            return RefreshIndicator(
              onRefresh: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                await vm.loadCycles();
              },

              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                padding: const EdgeInsets.all(16),

                children: [
                  // =========================
                  // SEARCH BAR
                  // =========================
                  SearchBarWidget(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },

                    onFilterTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      openFilterSheet();
                    },
                  ),

                  const SizedBox(height: 16),

                  // =========================
                  // EMPTY STATE
                  // =========================
                  if (filteredCycles.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,

                      child: const Center(child: EmptyFoodCycle()),
                    )
                  else
                    ...filteredCycles.map((cycle) {

                      final stats =
                      vm.getStats(
                        cycle.id,
                      );

                      return Padding(

                        padding:
                        const EdgeInsets.only(
                          bottom: 12,
                        ),

                        child: Dismissible(

                          key: Key(cycle.id),

                          direction:
                          DismissDirection
                              .horizontal,

                          movementDuration:
                          const Duration(
                            milliseconds: 250,
                          ),

                          resizeDuration:
                          const Duration(
                            milliseconds: 200,
                          ),

                          confirmDismiss:
                              (direction) async {

                            FocusManager.instance
                                .primaryFocus
                                ?.unfocus();

                            // =====================
                            // EDIT
                            // =====================

                            if (direction ==
                                DismissDirection
                                    .startToEnd) {

                              openEditSheet(cycle);

                              return false;
                            }

                            // =====================
                            // DELETE
                            // =====================

                            if (direction ==
                                DismissDirection
                                    .endToStart) {

                              final confirm =
                              await showDeleteDialog();

                              if (confirm) {

                                await deleteCycleWithUndo(
                                  cycle,
                                );
                              }

                              return false;
                            }

                            return false;
                          },

                          background:
                          swipeBackground(

                            color:
                            AppColors.accent,

                            icon:
                            Icons.edit,

                            alignment:
                            Alignment.centerLeft,
                          ),

                          secondaryBackground:
                          swipeBackground(

                            color: Colors.red,

                            icon: Icons.delete,

                            alignment:
                            Alignment.centerRight,
                          ),

                          child: FoodCycleCard(

                            title: cycle.title ?? "Untitled",

                            
                            cost:
                            "₹ ${cycle.monthlyAmount.toStringAsFixed(0)}",

                            status:
                            cycle.status.name,

                            highlight:
                            cycle.status ==
                                CycleStatus.active,

                            dateRange:
                            formatDateRange(
                              cycle,
                            ),

                            totalTiffin:
                            stats.totalTiffin,

                            totalEaten:
                            stats.totalMeals,

                            remainingTiffin:
                            stats.remaining,

                            progress:
                            stats.progress,

                            onTap: () {

                              openDetail(
                                cycle,
                              );
                            },
                          ),
                        ),
                      );
                    }),                ],
              ),
            );
          },
        ),
      ),
      // =========================
      // FAB
      // =========================
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: openCreateSheet,

        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // =========================
  // DELETE CONFIRM DIALOG
  // =========================

  Future<bool> showDeleteDialog() async {
    final result = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title:  Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),

              SizedBox(width: 10),

              Text("Delete Cycle", style: TextStyle(color: AppColors.accent)),
            ],
          ),

          content: const Text(
            "Are you sure you want to delete this food cycle?",

            style: TextStyle(height: 1.4),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
