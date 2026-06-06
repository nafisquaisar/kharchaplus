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
    final horizontalPadding = (width * 0.055).clamp(14.0, 24.0).toDouble();
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return SafeArea(
      top: false,
      left: false,
      right: false,
      minimum: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ),

        child: ClipRRect(
          borderRadius:
          BorderRadius.circular(10),

          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 35,
              sigmaY: 35,
            ),

            child: Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),

              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(10),

                /// ✨ PREMIUM GLASS
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                    Colors.white
                        .withOpacity(0.10),

                    Colors.white
                        .withOpacity(0.04),
                  ]
                      : [
                    Colors.white
                        .withOpacity(0.65),

                    Colors.white
                        .withOpacity(0.25),
                  ],
                ),

                border: Border.all(
                  color: isDark
                      ? Colors.white
                      .withOpacity(0.12)
                      : Colors.white
                      .withOpacity(0.7),
                  width: 1,
                ),

                boxShadow: [

                  /// Outer Glow
                  BoxShadow(
                    color: isDark
                        ? Colors.black
                        .withOpacity(0.35)
                        : Colors.black
                        .withOpacity(0.08),

                    blurRadius: 30,
                    spreadRadius: 2,

                    offset:
                    const Offset(0, 10),
                  ),

                  /// Accent Glow
                  BoxShadow(
                    color: AppColors.accent
                        .withOpacity(
                      isDark ? 0.10 : 0.05,
                    ),

                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ],
              ),

              child: Row(
                children: [

                  _buildItem(
                    context,
                    icon: Icons.home_rounded,
                    label: "Home",
                    index: 0,
                  ),

                  _buildItem(
                    context,
                    icon: Icons
                        .account_balance_wallet_rounded,
                    label: "Expense",
                    index: 1,
                  ),

                  _buildItem(
                    context,
                    icon:
                    Icons.track_changes_rounded,
                    label: "Tracking",
                    index: 2,
                  ),

                  _buildItem(
                    context,
                    icon:
                    Icons.person_outline_rounded,
                    label: "Profile",
                    index: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required int index,
      }) {

    final width =
        MediaQuery.of(context).size.width;
    final iconSize = (width * 0.06).clamp(22.0, 28.0).toDouble();
    final fontSize = (width * 0.028).clamp(11.0, 13.0).toDouble();
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final isSelected =
        currentIndex == index;

    return Expanded(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 3,
        ),

        child: Material(
          color: Colors.transparent,

          child: InkWell(
            onTap: () => onTap(index),

            borderRadius:
            BorderRadius.circular(10),

            splashColor:
            AppColors.accent.withOpacity(
              0.12,
            ),

            highlightColor:
            Colors.transparent,

            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 280,
              ),

              curve: Curves.easeOutExpo,

              padding:
              const EdgeInsets.symmetric(
                vertical: 11,
              ),

              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(10),

                /// ✨ Selected Glass
                gradient: isSelected
                    ? LinearGradient(
                  begin:
                  Alignment.topLeft,
                  end: Alignment
                      .bottomRight,

                  colors: isDark
                      ? [
                    Colors.white
                        .withOpacity(
                        0.16),

                    Colors.white
                        .withOpacity(
                        0.06),
                  ]
                      : [
                    Colors.white
                        .withOpacity(
                        0.85),

                    Colors.white
                        .withOpacity(
                        0.35),
                  ],
                )
                    : null,

                border: isSelected
                    ? Border.all(
                  color: isDark
                      ? Colors.white
                      .withOpacity(
                      0.12)
                      : Colors.white
                      .withOpacity(
                      0.8),
                )
                    : null,

                boxShadow: isSelected
                    ? [

                  /// Premium Active Glow
                  BoxShadow(
                    color: AppColors
                        .accent
                        .withOpacity(
                      isDark
                          ? 0.18
                          : 0.08,
                    ),

                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ]
                    : [],
              ),

              child: Column(
                mainAxisSize:
                MainAxisSize.min,

                children: [

                  AnimatedScale(
                    duration:
                    const Duration(
                      milliseconds: 250,
                    ),

                    scale:
                    isSelected
                        ? 1.08
                        : 1,

                    child: Icon(
                      icon,

                      size: iconSize,

                      color: isSelected
                          ? AppColors.accent
                          : isDark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 4),

                  AnimatedDefaultTextStyle(
                    duration:
                    const Duration(
                      milliseconds: 250,
                    ),

                    style: TextStyle(
                      fontSize: fontSize,

                      fontWeight:
                      isSelected
                          ? FontWeight.w700
                          : FontWeight
                          .w500,

                      color: isSelected
                          ? AppColors.accent
                          : isDark
                          ? Colors.white70
                          : Colors.black54,
                    ),

                    child: Text(label),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}