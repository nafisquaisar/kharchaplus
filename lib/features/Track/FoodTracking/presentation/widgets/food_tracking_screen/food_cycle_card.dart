import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

class FoodCycleCard extends StatelessWidget {
  final String title;

  final String cost;
  final String status;

  final bool highlight;

  final String dateRange;

  final int totalTiffin;

  final int totalEaten;

  final int remainingTiffin;

  final VoidCallback onTap;

  final double progress;

  const FoodCycleCard({
    super.key,
    required this.title,
    required this.cost,
    required this.status,
    required this.highlight,
    required this.dateRange,
    required this.totalTiffin,
    required this.totalEaten,
    required this.remainingTiffin,
    required this.onTap,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final progress = totalTiffin == 0 ? 0.0 : totalEaten / totalTiffin;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.only(
          top: 12,
          left: 12,
          right: 12,
          bottom: 2,
        ),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================
            // TOP ROW
            // =====================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: width * 0.040,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        dateRange,
                        style: TextStyle(
                          fontSize: width * 0.030,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Align(
                  alignment: Alignment.centerRight,

                  child: Text(
                    "${(progress * 100).toStringAsFixed(0)}% Completed",

                    style: TextStyle(
                      fontSize: width * 0.028,

                      color: Colors.grey.shade600,

                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: highlight
                        ? Colors.green.withOpacity(0.10)
                        : Colors.grey.withOpacity(0.10),

                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Text(
                    status,

                    style: TextStyle(
                      fontSize: width * 0.028,

                      fontWeight: FontWeight.w600,

                      color: highlight ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2),

            // =====================
            // PRICE + TIFFIN
            // =====================
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Monthly Amount",

                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        cost,

                        style: TextStyle(
                          fontSize: width * 0.058,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Total",

                      style: TextStyle(
                        fontSize: width * 0.026,

                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "$totalTiffin",

                      style: TextStyle(
                        fontSize: width * 0.032,

                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 10,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Eaten",

                      style: TextStyle(
                        fontSize: width * 0.026,

                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "$totalEaten",

                      style: TextStyle(
                        fontSize: width * 0.032,

                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 10,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Remaining",

                      style: TextStyle(
                        fontSize: width * 0.026,

                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "$remainingTiffin",

                      style: TextStyle(
                        fontSize: width * 0.032,

                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),


              ],
            ),

            const SizedBox(height: 14),

            // =====================
            // PROGRESS
            // =====================
            ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: LinearProgressIndicator(
                value: progress,

                minHeight: 7,

                backgroundColor: Colors.grey.shade200,

                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
