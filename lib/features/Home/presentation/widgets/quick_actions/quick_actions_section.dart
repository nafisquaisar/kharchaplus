import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class QuickActionsSection
    extends StatelessWidget {

  const QuickActionsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: 8,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          /// TITLE
          Text(
            "Quick Actions",

            style: TextStyle(
              fontSize:
              width * 0.048,

              fontWeight:
              FontWeight.bold,

              color:
              AppColors.black,
            ),
          ),

          SizedBox(
            height: width * 0.035,
          ),

          /// ACTIONS
          Row(
            children: [

              Expanded(
                child: _actionCard(
                  width: width,

                  icon:
                  Icons.account_balance_wallet,

                  title:
                  "Add Expense",

                  iconColor:
                  AppColors.primary,
                ),
              ),

              SizedBox(
                width:
                width * 0.025,
              ),

              Expanded(
                child: _actionCard(
                  width: width,

                  icon:
                  Icons.restaurant,

                  title:
                  "Add Food Cycle",

                  iconColor:
                  Colors.orange,
                ),
              ),

              SizedBox(
                width:
                width * 0.025,
              ),

              Expanded(
                child: _actionCard(
                  width: width,

                  icon:
                  Icons.bolt,

                  title:
                  "Add Electric Bill",

                  iconColor:
                  Colors.amber,
                ),
              ),

              SizedBox(
                width:
                width * 0.025,
              ),

              Expanded(
                child: _actionCard(
                  width: width,

                  icon:
                  Icons.water_drop,

                  title:
                  "Add Water",

                  iconColor:
                  AppColors.primary,
                ),
              ),

              SizedBox(
                width:
                width * 0.025,
              ),

              Expanded(
                child: _actionCard(
                  width: width,

                  icon:
                  Icons.more_horiz,

                  title:
                  "More",

                  iconColor:
                  AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required double width,
    required IconData icon,
    required String title,
    required Color iconColor,
  }) {

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: width * 0.03,
        horizontal: width * 0.02,
      ),

      decoration: BoxDecoration(
        color: AppColors.card,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color:
          AppColors.border,
        ),

        boxShadow: [

          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.03,
            ),

            blurRadius: 8,

            offset:
            const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Container(
            padding:
            const EdgeInsets.all(
              10,
            ),

            decoration: BoxDecoration(
              color:
              iconColor.withOpacity(
                0.12,
              ),

              shape:
              BoxShape.circle,
            ),

            child: Icon(
              icon,

              color: iconColor,

              size: width * 0.05,
            ),
          ),

          SizedBox(
            height: width * 0.02,
          ),

          Text(
            title,

            textAlign:
            TextAlign.center,

            maxLines: 2,

            overflow:
            TextOverflow.ellipsis,

            style: TextStyle(
              fontSize:
              width * 0.026,

              fontWeight:
              FontWeight.w600,

              color:
              AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}