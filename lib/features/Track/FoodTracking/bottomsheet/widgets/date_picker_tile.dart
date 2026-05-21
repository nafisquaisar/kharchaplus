import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';


class DatePickerTile extends StatelessWidget {

  final String title;

  final String value;

  final VoidCallback onTap;

  const DatePickerTile({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(

          color: AppColors.primarybg,

          borderRadius:
          BorderRadius.circular(16),
        ),

        child: Row(

          children: [

            Container(

              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(

                color: AppColors.map,

                borderRadius:
                BorderRadius.circular(12),
              ),

              child: Icon(
                Icons.calendar_month,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(

                    title,

                    style: TextStyle(
                      fontSize: 12,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(

                    value,

                    style: const TextStyle(

                      fontWeight:
                      FontWeight.w600,

                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}