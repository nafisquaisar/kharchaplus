import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/KharchaThemeColors.dart';
import '../../../../core/utils/AppFlushbar.dart';

import '../../data/model/ExpenseCardModel.dart';
import '../../data/repository/expense_repository.dart';

import '../../utils/ExpenseCardShimmer.dart';

import '../bottomsheet/CreateExpenseCardSheet/create_expense_card_sheet.dart';

import '../viewmodel/CategoryViewModel.dart';
import '../viewmodel/ExpenseCardViewModel.dart';
import '../viewmodel/ExpenseFilterViewModel.dart';
import '../viewmodel/expense_viewmodel.dart';

import '../widgets/ExpensePage/expense_card.dart';
import '../widgets/ExpensePage/expense_search_bar.dart';

import 'expense_detail_screen.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  Map<String, dynamic>? _lastDeleted;

  Timer? _deleteTimer;

  String searchQuery = "";

  final searchController = TextEditingController();

  final Set<String> _pendingDeleteIds = {};

  @override
  void initState() {
    super.initState();

    final userId = FirebaseAuth.instance.currentUser!.uid;

    Future.microtask(() {
      context.read<ExpenseCardViewModel>().listenCards(userId);
    });

    Future.microtask(() async {

      await context
          .read<CategoryViewModel>()
          .addDefaultCategories();
    });

  }

  @override
  void dispose() {
    _deleteTimer?.cancel();

    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpenseCardViewModel>();

    final userId = FirebaseAuth.instance.currentUser!.uid;

    /// =====================================================
    /// FILTERED LIST
    /// =====================================================

    final filteredCards = vm.cards.where((card) {
      /// HIDE PENDING DELETE

      if (_pendingDeleteIds.contains(card.id)) {
        return false;
      }

      final title = card.title.toLowerCase();

      final notes = card.notes?.toLowerCase() ?? "";

      return title.contains(searchQuery) || notes.contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),

      body: RefreshIndicator(
        displacement: 40,

        edgeOffset: 20,

        color: Colors.deepPurple,

        backgroundColor: Colors.white,

        onRefresh: () {
          return context.read<ExpenseCardViewModel>().refreshCards();
        },

        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),

          padding: const EdgeInsets.all(16),

          children: [
            /// =====================================================
            /// SEARCH
            /// =====================================================
            ExpenseSearchBar(
              controller: searchController,

              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),

            const SizedBox(height: 16),

            /// =====================================================
            /// SHIMMER
            /// =====================================================
            if (vm.isInitialLoading) const ExpenseCardShimmer(),

            /// =====================================================
            /// ERROR
            /// =====================================================
            if (!vm.isInitialLoading && vm.error != null)
              Center(
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
                        vm.error!,

                        style: const TextStyle(
                          fontSize: 16,

                          fontWeight: FontWeight.w600,
                        ),

                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 18),

                      ElevatedButton(
                        onPressed: () {
                          vm.listenCards(userId);
                        },

                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              ),

            /// =====================================================
            /// EMPTY
            /// =====================================================
            if (!vm.isInitialLoading &&
                vm.error == null &&
                filteredCards.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 100),

                  child: Column(
                    children: [
                      Icon(Icons.wallet_rounded, size: 70, color: Colors.grey),

                      SizedBox(height: 14),

                      Text(
                        "No Expense Cards",

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Create your first expense card",

                        style: TextStyle(color: Colors.grey),

                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

            /// =====================================================
            /// CARD LIST
            /// =====================================================
            if (!vm.isInitialLoading &&
                vm.error == null &&
                filteredCards.isNotEmpty)
              ...filteredCards.map((card) {
                final subtitle =
                    "${DateFormat('d MMM').format(card.startDate)} - "
                    "${DateFormat('d MMM').format(card.endDate)}";

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),

                  child: Dismissible(
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
                      /// =================================================
                      /// EDIT
                      /// =================================================

                      if (direction == DismissDirection.startToEnd) {
                        final result = await showModalBottomSheet(
                          context: context,

                          isScrollControlled: true,

                          backgroundColor: Colors.transparent,

                          builder: (_) {
                            return CreateExpenseCardSheet(card: card);
                          },
                        );

                        if (result != null && mounted) {
                          showSnack(result);
                        }

                        return false;
                      }

                      /// =================================================
                      /// DELETE CONFIRM
                      /// =================================================

                      return await showDialog(
                        context: context,

                        builder: (_) {
                          return AlertDialog(
                            title: const Text("Delete Expense Card"),

                            content: const Text(
                              "Are you sure you want to delete this expense card?",
                            ),

                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },

                                child: const Text("Cancel"),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },

                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },

                    onDismissed: (_) {
                      deleteCardWithUndo(card, userId);
                    },

                    child: ExpenseCard(
                      title: card.title,

                      subtitle: subtitle,

                      amount: card.totalExpense.toStringAsFixed(0),


                      items: "${card.totalItems} Items",

                      status: card.status,

                      progress: card.progress,

                      isHighlighted: card.status == "Active",

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) {
                              return MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(
                                    create: (_) =>
                                        ExpenseViewModel(ExpenseRepository())
                                          ..listenExpensesByCard(card.id),
                                  ),

                                  ChangeNotifierProvider(
                                    create: (_) => ExpenseFilterViewModel(),
                                  ),
                                ],

                                child: ExpenseDetailScreen(cardId: card.id),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,

        onPressed: () async {
          final result = await showModalBottomSheet(
            context: context,

            isScrollControlled: true,

            backgroundColor: Colors.transparent,

            builder: (_) {
              return const CreateExpenseCardSheet();
            },
          );

          if (result != null && mounted) {
            showSnack(result);
          }
        },

        child: const Icon(Icons.add, color: AppColors.textPrimary),
      ),
    );
  }

  /// =====================================================
  /// DELETE WITH UNDO
  /// =====================================================

  Future<void> deleteCardWithUndo(ExpenseCardModel card, String userId) async {
    /// HIDE UI INSTANTLY

    setState(() {
      _pendingDeleteIds.add(card.id);
    });

    /// TEMP SAVE

    _lastDeleted = {"card": card};

    /// SHOW UNDO

    AppFlushbar.showUndo(
      context,

      message: "Expense card deleted",

      onUndo: () async {
        _deleteTimer?.cancel();

        setState(() {
          _pendingDeleteIds.remove(card.id);
        });

        _lastDeleted = null;
      },
    );

    /// AUTO DELETE AFTER 5 SEC

    _deleteTimer?.cancel();

    _deleteTimer = Timer(const Duration(seconds: 5), () async {
      if (_lastDeleted != null) {
        await context.read<ExpenseCardViewModel>().deleteCard(userId, card.id);

        _lastDeleted = null;
      }
    });
  }

  /// =====================================================
  /// FLUSHBAR
  /// =====================================================

  void showSnack(String type) {
    if (type == "updated") {
      AppFlushbar.showSuccess(context, "Expense updated");
    } else if (type == "created") {
      AppFlushbar.showSuccess(context, "Expense created");
    } else {
      AppFlushbar.showInfo(context, "Expense deleted");
    }
  }

  /// =====================================================
  /// SWIPE BG
  /// =====================================================

  Widget swipeBackground({
    required Color color,

    required IconData icon,

    required Alignment alignment,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      alignment: alignment,

      decoration: BoxDecoration(
        color: color.withOpacity(0.12),

        borderRadius: BorderRadius.circular(18),
      ),

      child: Icon(icon, color: color),
    );
  }
}
