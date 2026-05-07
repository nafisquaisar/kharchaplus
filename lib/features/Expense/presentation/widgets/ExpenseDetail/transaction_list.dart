import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/AppFlushbar.dart';
import '../../../data/model/ExpenseModel.dart';
import '../../bottomsheet/AddExpenseSheet/add_expense_sheet.dart';
import '../../viewmodel/expense_viewmodel.dart';
import '../ExpensePage/expense_list_item.dart';


class TransactionList
    extends StatefulWidget {

  final List<ExpenseModel> expenses;

  const TransactionList({
    super.key,
    required this.expenses,
  });

  @override
  State<TransactionList> createState() =>
      _TransactionListState();
}

class _TransactionListState
    extends State<TransactionList> {

  ExpenseModel? _lastDeleted;

  Timer? _deleteTimer;

  late List<ExpenseModel>
  _localExpenses;

  @override
  void initState() {
    super.initState();

    _localExpenses =
        List.from(widget.expenses);
  }

  @override
  void didUpdateWidget(
      covariant TransactionList oldWidget,
      ) {

    super.didUpdateWidget(
      oldWidget,
    );

    _localExpenses =
        List.from(widget.expenses);
  }

  /// =====================================================
  /// DELETE WITH UNDO
  /// =====================================================

  Future<void> deleteExpense(ExpenseModel expense,) async {

    /// SAVE TEMP

    _lastDeleted = expense;

    /// REMOVE UI INSTANTLY

    setState(() {

      _localExpenses.removeWhere(
            (e) =>
        e.id == expense.id,
      );
    });

    /// SHOW UNDO

    AppFlushbar.showUndo(

      context,

      message:
      "Expense deleted",

      onUndo: () {

        _deleteTimer?.cancel();

        if (_lastDeleted == null) {
          return;
        }

        setState(() {

          _localExpenses.insert(
            0,
            _lastDeleted!,
          );
        });

        _lastDeleted = null;
      },
    );

    /// WAIT 5 SEC

    _deleteTimer?.cancel();

    _deleteTimer = Timer(

      const Duration(
        seconds: 5,
      ),

          () async {

        /// USER DIDN'T UNDO

        if (_lastDeleted != null) {

          await context
              .read<
              ExpenseViewModel>()
              .softDeleteExpense(
            expense,
          );

          _lastDeleted = null;
        }
      },
    );
  }

  @override
  void dispose() {

    _deleteTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(

      children:
      _localExpenses.map((e) {

        return ExpenseListItem(

          expense: e,

          /// =========================================
          /// UPDATE
          /// =========================================

          onEdit: () async {

            await showModalBottomSheet(

              context: context,

              isScrollControlled:
              true,

              backgroundColor:
              Colors.transparent,

              builder: (_) {

                return DraggableScrollableSheet(

                  initialChildSize:
                  0.82,

                  minChildSize:
                  0.60,

                  maxChildSize:
                  0.95,

                  expand: false,

                  builder: (
                      context,
                      scrollController,
                      ) {

                    return Container(

                      decoration:
                      const BoxDecoration(

                        color:
                        Colors.white,

                        borderRadius:
                        BorderRadius.vertical(
                          top:
                          Radius.circular(
                            30,
                          ),
                        ),
                      ),

                      child: ClipRRect(

                        borderRadius:
                        const BorderRadius.vertical(
                          top:
                          Radius.circular(
                            30,
                          ),
                        ),

                        child:
                        SingleChildScrollView(

                          controller:
                          scrollController,

                          physics:
                          const BouncingScrollPhysics(),

                          child:
                          AddExpenseSheet(

                            expense: e,

                            cardId:
                            e.cardId,

                            buttonText:
                            "Update Expense",

                            onAdd:
                                (
                                updatedExpense,
                                ) async {

                              await context
                                  .read<
                                  ExpenseViewModel>()
                                  .updateExpense(

                                updatedExpense,

                                e.amount,
                              );

                              if (context
                                  .mounted) {

                                Navigator.pop(
                                  context,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },

          /// =========================================
          /// DELETE
          /// =========================================

          onDelete: () async {

            await deleteExpense(
              e,
            );
          },
        );
      }).toList(),
    );
  }
}