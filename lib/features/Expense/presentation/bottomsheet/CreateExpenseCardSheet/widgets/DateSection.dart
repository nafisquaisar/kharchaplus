import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DateTile.dart';
import 'SectionCard.dart';

class DateSection extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;

  const DateSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartTap,
    required this.onEndTap,
  });

  String format(DateTime? d) =>
      d == null ? "Select date" : DateFormat("d MMM yyyy").format(d);

  @override
  Widget build(BuildContext context) {
    final isInvalid =
        startDate != null && endDate != null && endDate!.isBefore(startDate!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔥 TITLE
        Text(
          "Date Range",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(height: 10),

        /// 🔥 CARD
        SectionCard(
          child: Column(
            children: [
              DateTile(
                title: "Start Date",
                value: format(startDate),
                onTap: onStartTap,
                icon: Icons.calendar_today_outlined,
              ),

              const Divider(height: 20),

              DateTile(
                title: "End Date",
                value: format(endDate),
                onTap: onEndTap,
                icon: Icons.event_outlined,
              ),
            ],
          ),
        ),

        /// 🔥 ERROR UI
        if (isInvalid) ...[
          const SizedBox(height: 8),
          Text(
            "End date cannot be before start date",
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}