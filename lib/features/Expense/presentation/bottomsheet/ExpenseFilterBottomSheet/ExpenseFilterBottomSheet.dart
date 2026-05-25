import 'package:flutter/material.dart';
import '../../../data/model/ExpenseFilterModel.dart';
import 'widgets/filter_action_buttons.dart';
import 'widgets/filter_drag_handle.dart';
import 'widgets/filter_header.dart';
import 'widgets/payment_filter_section.dart';
import 'widgets/date_filter_section.dart';
import 'widgets/sort_filter_section.dart';

class ExpenseFilterBottomSheet extends StatefulWidget {

  final ExpenseFilterModel initialFilter;

  const ExpenseFilterBottomSheet({
    super.key,
    required this.initialFilter,
  });

  @override
  State<ExpenseFilterBottomSheet>
  createState() =>
      _ExpenseFilterBottomSheetState();
}

class _ExpenseFilterBottomSheetState
    extends State<ExpenseFilterBottomSheet> {

  late ExpenseFilterModel filter;

  @override
  void initState() {
    super.initState();

    filter = widget.initialFilter;
  }

  void resetFilters() {

    setState(() {

      filter =
      const ExpenseFilterModel();
    });
  }

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(

      child: Container(

        padding:
        const EdgeInsets.all(20),

        decoration:
        BoxDecoration(

          color: colorScheme.surface,

          borderRadius:
          BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),

        child: SingleChildScrollView(

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              const FilterDragHandle(),

              const SizedBox(height: 18),

              FilterHeader(
                onReset: resetFilters,
              ),

              const SizedBox(height: 28),

              SortFilterSection(

                selected:
                filter.sortType,

                onChanged: (value) {

                  setState(() {

                    filter =
                        filter.copyWith(
                          sortType: value,
                        );
                  });
                },
              ),

              const SizedBox(height: 28),

              PaymentFilterSection(

                selected:
                filter.paymentMode,

                onChanged: (value) {

                  setState(() {

                    filter =
                        filter.copyWith(
                          paymentMode: value,
                        );
                  });
                },
              ),

              const SizedBox(height: 28),

              DateFilterSection(

                startDate:
                filter.startDate,

                endDate:
                filter.endDate,

                onChanged:
                    (start, end) {

                  setState(() {

                    filter =
                        filter.copyWith(
                          startDate: start,
                          endDate: end,
                        );
                  });
                },
              ),

              const SizedBox(height: 34),

              FilterActionButtons(

                onCancel: () {

                  Navigator.pop(context);
                },

                onApply: () {

                  Navigator.pop(
                    context,
                    filter,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}