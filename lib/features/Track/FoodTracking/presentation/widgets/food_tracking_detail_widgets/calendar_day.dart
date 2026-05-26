import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

class CalendarDay extends StatelessWidget {

  final DateTime date;

  final bool selected;

  final bool lunch;

  final bool dinner;

  final bool special;

  final VoidCallback onTap;

  const CalendarDay({
    super.key,

    required this.date,

    required this.selected,

    required this.lunch,

    required this.dinner,

    required this.special,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(

      builder: (context, constraints) {

        final cellHeight =
            constraints.maxHeight;

        final bool compact =
            cellHeight < 62;

        final double dateSize =
        compact ? 30 : 36;

        final double fontSize =
        compact ? 11 : 13;

        final double dotSize =
        compact ? 4 : 5;

        return Material(

          color: Colors.transparent,

          child: InkWell(

            onTap: onTap,

            borderRadius:
            BorderRadius.circular(14),

            child: SizedBox.expand(

              child: Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  // =========================
                  // DATE CIRCLE
                  // =========================

                  AnimatedContainer(

                    duration:
                    const Duration(
                      milliseconds: 180,
                    ),

                    width: dateSize,

                    height: dateSize,

                    alignment: Alignment.center,

                    decoration: BoxDecoration(

                      gradient:

                      selected
                          ? AppColors
                          .kharchaGradient
                          : null,

                      color:
                      selected
                          ? null
                          : Colors.transparent,

                      shape: BoxShape.circle,

                      border:

                      special

                          ? Border.all(
                        color: Colors.red,
                        width: 2,
                      )

                          : null,

                      boxShadow: selected

                          ? [

                        BoxShadow(

                          color:
                          AppColors
                              .primary
                              .withOpacity(
                            0.25,
                          ),

                          blurRadius: 8,

                          offset:
                          const Offset(
                            0,
                            3,
                          ),
                        ),
                      ]

                          : [],
                    ),

                    child: Text(

                      "${date.day}",

                      style: TextStyle(

                        color:
                        selected
                            ? Colors.white
                            : colorScheme.onSurface,

                        fontWeight:
                        FontWeight.w600,

                        fontSize: fontSize,
                      ),
                    ),
                  ),

                  // =========================
                  // DOTS
                  // =========================

                  if (lunch || dinner)

                    Padding(

                      padding:
                      const EdgeInsets.only(
                        top: 3,
                      ),

                      child: Row(

                        mainAxisSize:
                        MainAxisSize.min,

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          if (lunch)

                            Container(

                              width: dotSize,

                              height: dotSize,

                              decoration:
                              const BoxDecoration(

                                color:
                                Colors.green,

                                shape:
                                BoxShape.circle,
                              ),
                            ),

                          if (dinner) ...[

                            const SizedBox(
                              width: 2,
                            ),

                            Container(

                              width: dotSize,

                              height: dotSize,

                              decoration:
                              const BoxDecoration(

                                color:
                                Colors.orange,

                                shape:
                                BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
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