import 'package:expense_tracker/features/Expense/presentation/widgets/ExpenseDetail/summary_trend.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/KharchaThemeColors.dart';

class SummaryHeader extends StatelessWidget {
  final String startDate;
  final String endDate;
  final String trendText;

  const SummaryHeader({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.trendText,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ important
      children: [

        /// 🔥 ICON BOX
        Container(
          padding: EdgeInsets.all(width * 0.025),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1), // ✅ FIXED
            borderRadius: BorderRadius.circular(width * 0.01),
          ),
          child: Icon(
            Icons.calendar_today,
            color: AppColors.accent,
            size: width * 0.05,
          ),
        ),

        SizedBox(width: width * 0.01),

        /// 🔥 DATE TEXT
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Text(
              "$startDate – $endDate",
              style: TextStyle(
                fontSize: width * 0.035,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: width * 0.001),

            SummaryTrend(text: trendText),

          ],
        ),
      ],
    );
  }
}