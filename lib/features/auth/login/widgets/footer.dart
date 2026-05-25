import 'package:expense_tracker/features/auth/login/data/Reason.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final List<Reason> reasons = [
    Reason(
      icon: CupertinoIcons.doc_text,
      title: "Track Expenses",
      subtitle: "Record every spending easily",
    ),
    Reason(
      icon: CupertinoIcons.chart_bar,
      title: "Smart Insights",
      subtitle: "Understand your spending habits",
    ),
    Reason(
      icon: CupertinoIcons.money_dollar_circle,
      title: "Stay in Control",
      subtitle: "Avoid overspending and save more",
    ),
  ];

   Footer({super.key});


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        SizedBox(height: 10),

        Row(
          children: [
            Expanded(child: Divider(color: colorScheme.outline, thickness: 2)),
            SizedBox(width: 10),
            Text(
              "Why Kharcha Plus ?",
              style: textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: 10),
            Expanded(child: Divider(color: colorScheme.outline, thickness: 2)),
          ],
        ),


        Column(
          children: reasons.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: colorScheme.primary, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(height: 4),
                        Text(item.subtitle,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}