import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ElectricityTracking/presentation/screens/ElectricityTrackingScreen.dart';

import '../../FoodTracking/presentation/screens/food_tracking_screen.dart';

import '../../WaterTracking/presentation/screens/water_screen.dart';

import '../../data/models/tracking_model.dart';

import '../provider/tracking_provider.dart';

import '../widgets/tracking_card.dart';

class TrackingScreen extends ConsumerWidget {

  const TrackingScreen({super.key});

  /// =========================================
  /// OPEN MODULE SCREEN
  /// =========================================

  void openScreen(
      BuildContext context,
      TrackingModel tracking,
      ) {

    final type =
    tracking.type.toLowerCase();

    if (type == "food") {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const FoodTrackingScreen(),
        ),
      );

    } else if (type == "electricity") {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const ElectricityTrackingScreen(),
        ),
      );

    } else if (type == "water") {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const WaterScreen(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "${tracking.type} not implemented yet",
          ),
        ),
      );
    }
  }

  /// =========================================
  /// DEFAULT MODEL
  /// =========================================

  TrackingModel defaultTracking({

    required String type,

    required String iconType,

    required String color,
  }) {

    return TrackingModel(

      type: type,

      totalAmount: 0,

      todayAmount: 0,

      monthlyAmount: 0,

      activeCycles: 0,

      totalRecords: 0,

      isActive: true,

      progressPercent: 0,

      status: "Active",

      iconType: iconType,

      categoryColor: color,

      createdAt: DateTime.now(),

      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final trackingAsync =
    ref.watch(trackingProvider);

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FF),

      body: SafeArea(

        child: trackingAsync.when(

          /// =====================================
          /// DATA
          /// =====================================

          data: (trackingList) {

            /// =====================================
            /// CONVERT FIREBASE LIST TO MAP
            /// =====================================

            final trackingMap = {

              for (var item in trackingList)

                item.type.toLowerCase(): item,
            };

            /// =====================================
            /// FIXED MODULES
            /// =====================================

            final modules = [

              trackingMap["food"] ??

                  defaultTracking(

                    type: "food",

                    iconType: "food",

                    color: "#4CAF50",
                  ),

              trackingMap["electricity"] ??

                  defaultTracking(

                    type: "electricity",

                    iconType: "electricity",

                    color: "#FFC107",
                  ),

              trackingMap["water"] ??

                  defaultTracking(

                    type: "water",

                    iconType: "water",

                    color: "#2196F3",
                  ),
            ];

            return ListView(

              padding:
              const EdgeInsets.all(16),

              children: [

                const SizedBox(height: 6),

                const Text(

                  "Tracking Modules",

                  style: TextStyle(

                    fontWeight:
                    FontWeight.bold,

                    fontSize: 24,
                  ),
                ),

                const SizedBox(height: 6),

                Text(

                  "Monitor all your tracking data",

                  style: TextStyle(

                    color: Colors.grey.shade600,

                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),

                /// =====================================
                /// TRACKING CARDS
                /// =====================================

                ...modules.map(

                      (tracking) => TrackingCard(

                    tracking: tracking,

                    onTap: () {

                      openScreen(
                        context,
                        tracking,
                      );
                    },
                  ),
                ),
              ],
            );
          },

          /// =====================================
          /// LOADING
          /// =====================================

          loading: () {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          },

          /// =====================================
          /// ERROR
          /// =====================================

          error: (e, _) {

            return Center(

              child: Padding(

                padding:
                const EdgeInsets.all(20),

                child: Column(

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    const Icon(

                      Icons.error_outline,

                      size: 60,

                      color: Colors.red,
                    ),

                    const SizedBox(height: 14),

                    const Text(

                      "Something went wrong",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(

                      e.toString(),

                      textAlign:
                      TextAlign.center,

                      style: TextStyle(

                        color:
                        Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}