import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'filter_section_title.dart';

class DateFilterSection
    extends StatelessWidget {

  final DateTime? startDate;
  final DateTime? endDate;

  final Function(
      DateTime start,
      DateTime end,
      ) onChanged;

  const DateFilterSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onChanged,
  });

  Future<void> _pickDateRange(
      BuildContext context,
      ) async {

    final picked =
    await showDateRangePicker(

      context: context,

      firstDate: DateTime(2020),

      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    onChanged(
      picked.start,
      picked.end,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const FilterSectionTitle(
          title: 'Date Range',
        ),

        const SizedBox(height: 14),

        GestureDetector(

          onTap: () {
            _pickDateRange(context);
          },

          child: Container(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            decoration: BoxDecoration(

              border: Border.all(
                color: colorScheme.outlineVariant,
              ),

              borderRadius:
              BorderRadius.circular(16),
            ),

            child: Row(

              children: [

                Icon(
                  Icons.calendar_month,
                  color: colorScheme.onSurfaceVariant,
                ),

                const SizedBox(width: 12),

                Expanded(

                  child: Text(

                    startDate != null &&
                        endDate != null
                        ? '${DateFormat('dd MMM yyyy').format(startDate!)} - ${DateFormat('dd MMM yyyy').format(endDate!)}'
                        : 'Select date range',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}