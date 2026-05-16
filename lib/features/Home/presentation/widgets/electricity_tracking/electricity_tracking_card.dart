import 'package:expense_tracker/features/Track/ElectricityTracking/presentation/screens/ElectricityTrackingScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class ElectricityTrackingCard extends StatelessWidget {
  const ElectricityTrackingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: 6,
      ),

      padding: EdgeInsets.all(
        width * 0.03,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 TOP ROW
          InkWell(

            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ElectricityTrackingScreen())
              );
            },

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),

                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.08),

                        shape: BoxShape.circle,
                      ),

                      child: Icon(
                        Icons.bolt_rounded,
                        size: 16,
                        color: const Color(0xFF2D8C82),
                      ),
                    ),

                    SizedBox(width: width * 0.03),

                    Text(
                      "Electricity Tracking",

                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: width * 0.065,
                ),
              ],
            ),
          ),

          SizedBox(height: width * 0.02),

          /// 📊 MIDDLE SECTION
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [
              /// LEFT
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      "This Month",

                      style: TextStyle(
                        color:
                        AppColors.textSecondary,

                        fontSize: width * 0.033,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: width * 0.003),

                    Text(
                      "66 Units",

                      style: TextStyle(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    SizedBox(height: width * 0.012),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.025,
                        vertical: width * 0.008,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),

                        borderRadius:
                        BorderRadius.circular(30),
                      ),

                      child: Text(
                        "Pending",

                        style: TextStyle(
                          color:
                          const Color(0xFF475467),

                          fontWeight:
                          FontWeight.w600,

                          fontSize: width * 0.03,
                        ),
                      ),
                    ),

                    SizedBox(height: width * 0.02),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "₹660",

                            style: TextStyle(
                              color: AppColors.black,
                              fontWeight:
                              FontWeight.w700,
                              fontSize:
                              width * 0.055,
                            ),
                          ),

                          TextSpan(
                            text: " Bill",

                            style: TextStyle(
                              color: AppColors
                                  .textSecondary,

                              fontWeight:
                              FontWeight.w600,

                              fontSize:
                              width * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// RIGHT
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,

                        color:
                        const Color(0xFF2D8C82),

                        size: width * 0.043,
                      ),

                      Text(
                        "22%",

                        style: TextStyle(
                          color:
                          const Color(0xFF2D8C82),

                          fontWeight:
                          FontWeight.w700,

                          fontSize: width * 0.04,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: width * 0.002),

                  Text(
                    "vs Apr",

                    style: TextStyle(
                      color:
                      AppColors.textSecondary,

                      fontSize: width * 0.03,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: width * 0.03),

          /// 📈 GRAPH
          SizedBox(
            height: width * 0.18,

            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 8,

                minY: 0,
                maxY: 100,

                gridData:
                const FlGridData(show: false),

                titlesData:
                const FlTitlesData(show: false),

                borderData:
                FlBorderData(show: false),

                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,

                    color: const Color(0xFF2D8C82),

                    barWidth: 3,

                    belowBarData: BarAreaData(
                      show: true,

                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,

                        colors: [
                          const Color(
                            0xFF2D8C82,
                          ).withOpacity(0.18),

                          const Color(
                            0xFF2D8C82,
                          ).withOpacity(0.01),
                        ],
                      ),
                    ),

                    dotData: FlDotData(
                      show: true,

                      getDotPainter:
                          (
                          spot,
                          percent,
                          barData,
                          index,
                          ) {
                        return FlDotCirclePainter(
                          radius: 4,

                          color:
                          const Color(
                            0xFF2D8C82,
                          ),

                          strokeWidth: 0,
                        );
                      },
                    ),

                    spots: const [
                      FlSpot(0, 12),
                      FlSpot(1, 12),
                      FlSpot(2, 40),
                      FlSpot(3, 38),
                      FlSpot(4, 50),
                      FlSpot(5, 78),
                      FlSpot(6, 45),
                      FlSpot(7, 58),
                      FlSpot(8, 66),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}