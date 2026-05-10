import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/FoodCycle.dart';
import '../../domain/enum/SundayRule.dart';

import '../food_tracking_detail_widgets/calendar_widget.dart';
import '../food_tracking_detail_widgets/meal_date_key.dart';
import '../food_tracking_detail_widgets/meal_selector.dart';
import '../food_tracking_detail_widgets/summary_row.dart';
import '../viewmodel/food_cycle_viewmodel.dart';


class FoodTrackingDetailScreen extends StatefulWidget {

  final FoodCycle cycle;

  const FoodTrackingDetailScreen({
    super.key,
    required this.cycle,
  });

  @override
  State<FoodTrackingDetailScreen> createState() =>
      _FoodTrackingDetailScreenState();
}

class _FoodTrackingDetailScreenState
    extends State<FoodTrackingDetailScreen> {

  late DateTime selectedDate;

  late double price;

  late DateTime startDate;

  late DateTime endDate;

  late SundayRule sundayRule;

  final Map<String, Map<String, bool>>
  mealData = {};

  @override
  void initState() {

    super.initState();

    price = widget.cycle.mealPrice;

    startDate = normalizeDate(
      widget.cycle.startDate,
    );

    endDate = normalizeDate(
      widget.cycle.endDate,
    );

    sundayRule = widget.cycle.sundayRule;

    generateDates();

    selectedDate = clampDateToCycle(
      startDate,
      startDate,
      endDate,
    );
  }

  // =========================
  // GENERATE DATES
  // =========================

  void generateDates() {

    final previous =
    Map<String, Map<String, bool>>
        .from(mealData);

    mealData.clear();

    final DateTime start =
    normalizeDate(startDate);

    final DateTime end =
    normalizeDate(endDate);

    if (end.isBefore(start)) {

      mealData[getKey(start)] =
          mealState(
            previous,
            getKey(start),
          );

      return;
    }

    DateTime current = start;

    while (!current.isAfter(end)) {

      final key = getKey(current);

      mealData[key] = mealState(
        previous,
        key,
      );

      current = current.add(
        const Duration(days: 1),
      );
    }
  }

  // =========================
  // TOGGLE MEAL
  // =========================

  void toggleMeal(
      String key,
      String type,
      ) {

    if (type != 'lunch' &&
        type != 'dinner') {

      return;
    }

    setState(() {

      final day = mealState(
        mealData,
        key,
      );

      day[type] =
      !(day[type] ?? false);

      mealData[key] = day;
    });
  }

  // =========================
  // CALCULATIONS
  // =========================

  int get totalMeals {

    int count = 0;

    for (var day in mealData.values) {

      if (day["lunch"] ?? false) {
        count++;
      }

      if (day["dinner"] ?? false) {
        count++;
      }
    }

    return count;
  }

  int get lunchCount =>
      mealData.values
          .where(
            (d) => d["lunch"] ?? false,
      )
          .length;

  int get dinnerCount =>
      mealData.values
          .where(
            (d) => d["dinner"] ?? false,
      )
          .length;

  double get totalCost {

    return
      (totalMeals * price) +
          widget.cycle.monthlyFee;
  }

  // =========================
  // TITLE
  // =========================

  String get cycleTitle {

    const months = [

      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final startText =
        '${startDate.day} '
        '${months[startDate.month - 1]}';

    final endText =
        '${endDate.day} '
        '${months[endDate.month - 1]}';

    return '$startText - $endText';
  }

  // =========================
  // DATE PICKER
  // =========================

  Future<DateTime?> _pickDate(
      BuildContext context,
      DateTime initial,
      ) {

    return showDatePicker(

      context: context,

      initialDate: initial,

      firstDate: DateTime(2020),

      lastDate: DateTime(2100),
    );
  }

  // =========================
  // DISPLAY DATE
  // =========================

  String _displayDate(
      DateTime date,
      ) {

    const months = [

      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return
      '${date.day} '
          '${months[date.month - 1]} '
          '${date.year}';
  }

  // =========================
  // UPDATE CYCLE SHEET
  // =========================

  Future<void>
  _openUpdateCycleSheet() async {

    final controller =
    TextEditingController(
      text: price.toStringAsFixed(0),
    );

    DateTime draftStart = startDate;

    DateTime draftEnd = endDate;

    SundayRule draftSundayRule =
        sundayRule;

    await showModalBottomSheet<void>(

      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.white,

      shape:
      const RoundedRectangleBorder(

        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),

      builder: (sheetContext) {

        return StatefulBuilder(

          builder: (
              context,
              setModalState,
              ) {

            return Padding(

              padding: EdgeInsets.only(

                left: 16,

                right: 16,

                top: 16,

                bottom:
                MediaQuery.of(context)
                    .viewInsets
                    .bottom +
                    16,
              ),

              child: SingleChildScrollView(

                child: Column(

                  mainAxisSize:
                  MainAxisSize.min,

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Text(

                      'Update Cycle',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // PRICE

                    TextField(

                      controller: controller,

                      keyboardType:
                      const TextInputType
                          .numberWithOptions(
                        decimal: true,
                      ),

                      decoration:
                      const InputDecoration(

                        labelText:
                        'Price per meal',

                        border:
                        OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    // START DATE

                    ListTile(

                      contentPadding:
                      EdgeInsets.zero,

                      title:
                      const Text(
                        'Start date',
                      ),

                      subtitle:
                      Text(
                        _displayDate(
                          draftStart,
                        ),
                      ),

                      trailing:
                      const Icon(
                        Icons.calendar_today,
                      ),

                      onTap: () async {

                        final picked =
                        await _pickDate(
                          context,
                          draftStart,
                        );

                        if (picked == null) {
                          return;
                        }

                        setModalState(() {

                          draftStart =
                              normalizeDate(
                                picked,
                              );

                          if (draftEnd
                              .isBefore(
                            draftStart,
                          )) {

                            draftEnd =
                                draftStart;
                          }
                        });
                      },
                    ),

                    // END DATE

                    ListTile(

                      contentPadding:
                      EdgeInsets.zero,

                      title:
                      const Text(
                        'End date',
                      ),

                      subtitle:
                      Text(
                        _displayDate(
                          draftEnd,
                        ),
                      ),

                      trailing:
                      const Icon(
                        Icons.calendar_today,
                      ),

                      onTap: () async {

                        final picked =
                        await _pickDate(
                          context,
                          draftEnd,
                        );

                        if (picked == null) {
                          return;
                        }

                        final normalized =
                        normalizeDate(
                          picked,
                        );

                        if (normalized
                            .isBefore(
                          draftStart,
                        )) {

                          return;
                        }

                        setModalState(() {

                          draftEnd =
                              normalized;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    // SUNDAY RULE

                    DropdownButtonFormField<
                        SundayRule>(

                      initialValue:
                      draftSundayRule,

                      decoration:
                      const InputDecoration(

                        labelText:
                        'Sunday rule',

                        border:
                        OutlineInputBorder(),
                      ),

                      items: const [

                        DropdownMenuItem(

                          value:
                          SundayRule
                              .twoMeals,

                          child:
                          Text(
                            '2 Meals',
                          ),
                        ),

                        DropdownMenuItem(

                          value:
                          SundayRule
                              .oneMeal,

                          child:
                          Text(
                            '1 Meal',
                          ),
                        ),

                        DropdownMenuItem(

                          value:
                          SundayRule.off,

                          child:
                          Text(
                            'Off',
                          ),
                        ),
                      ],

                      onChanged: (value) {

                        if (value == null) {
                          return;
                        }

                        setModalState(() {

                          draftSundayRule =
                              value;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // SAVE BUTTON

                    SizedBox(

                      width: double.infinity,

                      child: ElevatedButton(

                        onPressed: () async {

                          final nextPrice =
                          double.tryParse(
                            controller.text,
                          );

                          if (nextPrice ==
                              null ||
                              nextPrice <= 0) {

                            ScaffoldMessenger.of(
                              sheetContext,
                            ).showSnackBar(

                              const SnackBar(

                                content: Text(
                                  'Enter a valid price.',
                                ),
                              ),
                            );

                            return;
                          }

                          try {

                            final updatedCycle =
                            widget.cycle
                                .copyWith(

                              mealPrice:
                              nextPrice,

                              startDate:
                              draftStart,

                              endDate:
                              draftEnd,

                              sundayRule:
                              draftSundayRule,

                              updatedAt:
                              DateTime.now(),

                              version:
                              widget.cycle
                                  .version +
                                  1,
                            );

                            await context
                                .read<
                                FoodCycleViewModel>()
                                .updateCycle(
                              updatedCycle,
                            );

                            setState(() {

                              price =
                                  nextPrice;

                              startDate =
                                  draftStart;

                              endDate =
                                  draftEnd;

                              sundayRule =
                                  draftSundayRule;

                              generateDates();

                              selectedDate =
                                  clampDateToCycle(
                                    selectedDate,
                                    startDate,
                                    endDate,
                                  );
                            });

                            Navigator.of(
                              sheetContext,
                            ).pop();

                          } catch (e) {

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(

                              SnackBar(
                                content: Text(
                                  e.toString(),
                                ),
                              ),
                            );
                          }
                        },

                        child:
                        const Text(
                          'Save Changes',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(cycleTitle),

        actions: [

          PopupMenuButton<String>(

            onSelected: (value) {

              if (value == 'update') {

                _openUpdateCycleSheet();
              }
            },

            itemBuilder: (_) => const [

              PopupMenuItem<String>(

                value: 'update',

                child: Text(
                  'Update Cycle',
                ),
              ),
            ],
          ),
        ],
      ),

      body: SafeArea(

        child: Column(

          children: [

            const SizedBox(
              height: 8,
            ),

            SummaryRow(

              totalMeals: totalMeals,

              lunch: lunchCount,

              dinner: dinnerCount,

              cost: totalCost,
            ),

            const SizedBox(
              height: 10,
            ),

            Expanded(

              child: CalendarWidget(

                mealData: mealData,

                selectedDate:
                selectedDate,

                cycleStartDate:
                startDate,

                cycleEndDate:
                endDate,

                onDateTap: (date) {

                  final clampedDate =
                  clampDateToCycle(

                    date,

                    startDate,

                    endDate,
                  );

                  setState(() {

                    selectedDate =
                        clampedDate;
                  });
                },
              ),
            ),

            MealSelector(

              date: selectedDate,

              data: mealData,

              onToggle: toggleMeal,

              sundayRule:
              sundayRule.name,
            ),
          ],
        ),
      ),
    );
  }
}