import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
          // =========================
          // TOP HEADER
          // =========================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                'This Month Expense',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),

              Row(
                children:  [
                  Text(
                    'May 2024',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(width: 2),

                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),

           SizedBox(height: 14),

          // =========================
          // MAIN CONTENT
          // =========================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // LEFT MAIN AMOUNT
              // =========================

              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: AppColors.primarybg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:  Icon(
                            Icons.account_balance_wallet_outlined,
                            color: AppColors.colorText,
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 10),

                         Expanded(
                          child: Text(
                            '₹880',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children:  [
                        Text(
                          'vs Apr 2024',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        SizedBox(width: 8),

                        Icon(
                          Icons.arrow_upward,
                          size: 14,
                          color: Colors.red,
                        ),

                        SizedBox(width: 2),

                        Text(
                          '12%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // =========================
              // RIGHT SMALL STATS
              // =========================

              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildMiniInfo(
                      icon: Icons.local_drink_outlined,
                      title: 'Drink',
                      value: '84L',
                    ),

                    const SizedBox(height: 8),

                    _buildMiniInfo(
                      icon: Icons.water_drop_outlined,
                      title: 'Tanker',
                      value: '420L',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarybg,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              icon,
              size: 14,
              color: AppColors.colorText,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style:  TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style:  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}