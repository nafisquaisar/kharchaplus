import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/AppColors.dart';

class CustomBottomNav extends StatelessWidget {

  final int currentIndex;

  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context).size.width;

    final bottomPadding =
        MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: width * 0.07,
        right: width * 0.07,
        bottom: bottomPadding == 0
            ? 16
            : bottomPadding,
      ),

      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(10),

        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 22,
            sigmaY: 22,
          ),

          child: Container(
            padding:
            const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 4,
            ),

            decoration: BoxDecoration(

              /// 🔥 GLASS EFFECT
              color:
              Colors.white.withOpacity(0.08),

              borderRadius:
              BorderRadius.circular(10),

              border: Border.all(
                color: Colors.white
                    .withOpacity(0.18),
                width: 1,
              ),

              boxShadow: [
                BoxShadow(
                  color: AppColors.accent
                      .withOpacity(0.3),

                  blurRadius: 25,

                  offset:
                  const Offset(0, 10),
                ),
              ],
            ),

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,

              children: [

                _buildItem(
                  Icons.home_rounded,
                  "Home",
                  0,
                  width,
                ),

                _buildItem(
                  Icons.account_balance_wallet_rounded,
                  "Expense",
                  1,
                  width,
                ),

                _buildItem(
                  Icons.track_changes_rounded,
                  "Tracking",
                  2,
                  width,
                ),

                // _buildItem(
                //   Icons.people_alt_outlined,
                //   "Friend",
                //   3,
                //   width,
                // ),

                _buildItem(
                  Icons.person_outline,
                  "Profile",
                  3,
                  width,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
      IconData icon,
      String label,
      int index,
      double width,
      ) {

    final bool isSelected =
        currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),

        behavior:
        HitTestBehavior.opaque,

        child: AnimatedContainer(
          duration:
          const Duration(
            milliseconds: 250,
          ),

          padding:
          const EdgeInsets.symmetric(
            vertical: 6,
          ),

          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.textSecondary.withOpacity(0.3)
                : Colors.transparent,

            borderRadius:
            BorderRadius.circular(16),
          ),

          child: Column(
            mainAxisSize:
            MainAxisSize.min,

            children: [

              Icon(
                icon,

                size: width * 0.06,

                color: isSelected
                    ? AppColors.accent
                    : AppColors
                    .textSecondary,
              ),

              const SizedBox(height: 4),

              FittedBox(
                child: Text(
                  label,

                  maxLines: 1,

                  style: TextStyle(
                    fontSize:
                    width * 0.028,

                    fontWeight:
                    isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,

                    color: isSelected
                        ? AppColors.accent
                        : AppColors
                        .textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}