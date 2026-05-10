import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

import 'section_card.dart';
import 'section_title.dart';

class CycleDurationSection
    extends StatelessWidget {

  final DateTime? startDate;

  final DateTime? endDate;

  final String Function(DateTime)
  formatDate;

  final VoidCallback
  onStartTap;

  final VoidCallback
  onEndTap;

  const CycleDurationSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.formatDate,
    required this.onStartTap,
    required this.onEndTap,
  });

  Widget buildDateTile({

    required String title,

    required String value,

    required VoidCallback onTap,
  }) {

    return InkWell(

      onTap: onTap,

      borderRadius:
      BorderRadius.circular(10),

      child: Container(

        padding:
        const EdgeInsets.symmetric(

          horizontal: 10,

          vertical: 2,
        ),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(12),

          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),

          boxShadow: [

            BoxShadow(

              color:
              AppColors.primary
                  .withOpacity(0.06),

              blurRadius: 6,

              offset: const Offset(
                0,
                2,
              ),
            ),
          ],
        ),

        child: Row(

          children: [

            // ICON BOX

            Container(

              height: 36,

              width: 36,

              decoration:
              BoxDecoration(

                color:
                AppColors.primarybg,

                borderRadius:
                BorderRadius.circular(
                  10,
                ),
              ),

              child: const Icon(

                Icons.calendar_month,

                color:
                AppColors.primary,

                size: 18,
              ),
            ),

            const SizedBox(width: 12),

            // TEXT

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Text(

                    title,

                    style:
                    TextStyle(

                      fontSize: 11,

                      color: Colors
                          .grey.shade500,

                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Text(

                    value,

                    style:
                    const TextStyle(

                      fontSize: 14,

                      fontWeight:
                      FontWeight.w600,

                      color:
                      Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            Icon(

              Icons.chevron_right,

              color:
              Colors.grey.shade400,

              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const SectionTitle(
          title: "Cycle Duration",
        ),

        SectionCard(

          child: Column(

            children: [

              buildDateTile(

                title: "Start Date",

                value:
                startDate == null

                    ? "Select date"

                    : formatDate(
                  startDate!,
                ),

                onTap: onStartTap,
              ),

              const SizedBox(
                height: 12,
              ),

              buildDateTile(

                title: "End Date",

                value:
                endDate == null

                    ? "Select date"

                    : formatDate(
                  endDate!,
                ),

                onTap: onEndTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}