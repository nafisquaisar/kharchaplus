import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ExpenseShimmer extends StatelessWidget {

  final int itemCount;

  const ExpenseShimmer({
    super.key,
    this.itemCount = 8,
  });

  @override
  Widget build(BuildContext context) {

    return ListView.separated(

      shrinkWrap: true,

      physics:
      const NeverScrollableScrollPhysics(),

      itemCount: itemCount,

      separatorBuilder:
          (_, __) =>
      const SizedBox(height: 14),

      itemBuilder: (_, index) {

        return Shimmer.fromColors(

          baseColor:
          Colors.grey.shade300,

          highlightColor:
          Colors.grey.shade100,

          period:
          const Duration(
            milliseconds: 1400,
          ),

          child: Container(

            padding:
            const EdgeInsets.all(16),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(24),

              boxShadow: [

                BoxShadow(

                  color: Colors.black
                      .withOpacity(0.03),

                  blurRadius: 12,

                  offset:
                  const Offset(0, 4),
                ),
              ],
            ),

            child: Row(

              children: [

                /// CATEGORY ICON

                Container(

                  width: 56,
                  height: 56,

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),

                const SizedBox(width: 14),

                /// TITLE + DATE

                Expanded(

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Container(

                        height: 15,

                        width:
                        double.infinity,

                        constraints:
                        const BoxConstraints(
                          maxWidth: 180,
                        ),

                        decoration: BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(

                        height: 12,

                        width: 90,

                        decoration: BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                /// AMOUNT

                Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.end,

                  children: [

                    Container(

                      height: 16,

                      width: 70,

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(

                      height: 12,

                      width: 40,

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}