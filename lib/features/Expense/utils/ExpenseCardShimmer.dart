import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ExpenseCardShimmer
    extends StatelessWidget {

  final int itemCount;

  const ExpenseCardShimmer({
    super.key,
    this.itemCount = 5,
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
              BorderRadius.circular(18),

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

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(

                  children: [

                    Container(

                      width: 48,
                      height: 48,

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                        BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Container(

                            height: 14,

                            width: 140,

                            decoration:
                            BoxDecoration(

                              color:
                              Colors.white,

                              borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Container(

                            height: 12,

                            width: 100,

                            decoration:
                            BoxDecoration(

                              color:
                              Colors.white,

                              borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(

                      height: 28,
                      width: 70,

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.white,

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Container(

                  height: 18,
                  width: 120,

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      8,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(

                  height: 8,

                  width: double.infinity,

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}