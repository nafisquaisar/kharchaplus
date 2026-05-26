import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/AppColors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void goToHome() {
    if (hasNavigated) return;

    hasNavigated = true;

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      '/home',
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF081018),
                    Color(0xFF0F2027),
                    Color(0xFF102530),
                    Color(0xFF134E5E),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Color(0xFFF4FBFA),
                    Color(0xFFEAF9F8),
                  ],
                ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              /// 🔥 TOP GLOW

              Positioned(
                top: -120,
                right: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(
                      isDark ? 0.10 : 0.08,
                    ),
                  ),
                ),
              ),

              /// 🔥 BOTTOM GLOW

              Positioned(
                bottom: -100,
                left: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withOpacity(
                      isDark ? 0.10 : 0.06,
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  const Spacer(),

                  /// 🔥 LOGO ANIMATION

                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0.96,
                      end: 1,
                    ),
                    duration: const Duration(
                      milliseconds: 1800,
                    ),
                    curve: Curves.easeInOut,
                    builder: (
                      context,
                      value,
                      child,
                    ) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: size.width * 0.72,
                      height: size.width * 0.72,
                      padding: const EdgeInsets.all(
                        18,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        gradient: RadialGradient(
                          colors: isDark
                              ? [
                                  const Color(
                                    0xFF102530,
                                  ),
                                  const Color(
                                    0xFF14313D,
                                  ),
                                ]
                              : [
                                  Colors.white,
                                  AppColors.primary.withOpacity(
                                    0.05,
                                  ),
                                ],
                        ),
                        border: Border.all(
                          color: isDark
                              ? Colors.white10
                              : Colors.white.withOpacity(
                                  0.7,
                                ),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(
                              isDark ? 0.18 : 0.12,
                            ),
                            blurRadius: 35,
                            spreadRadius: 2,
                            offset: const Offset(
                              0,
                              10,
                            ),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        child: Lottie.asset(
                          'assets/animation/splash4.json',
                          controller: _controller,
                          fit: BoxFit.cover,
                          repeat: true,
                          renderCache: RenderCache.raster,
                          onLoaded: (
                            composition,
                          ) {
                            _controller.duration = composition.duration;

                            _controller.repeat();

                            Future.delayed(
                              const Duration(
                                seconds: 4,
                              ),
                              () {
                                goToHome();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// 🔥 APP NAME

                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end: 1,
                    ),
                    duration: const Duration(
                      milliseconds: 1200,
                    ),
                    curve: Curves.easeOut,
                    builder: (
                      context,
                      value,
                      child,
                    ) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            25 * (1 - value),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: ShaderMask(
                      shaderCallback: (
                        bounds,
                      ) {
                        return AppColors.kharchaGradient.createShader(
                          bounds,
                        );
                      },
                      child: const Text(
                        "Kharcha Plus",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔥 LINE

                  Container(
                    width: 90,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        100,
                      ),
                      gradient: AppColors.buttonGradient,
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// 🔥 QUOTE

                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end: 1,
                    ),
                    duration: const Duration(
                      milliseconds: 1600,
                    ),
                    curve: Curves.easeOut,
                    builder: (
                      context,
                      value,
                      child,
                    ) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            12 * (1 - value),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 34,
                      ),
                      child: Text(
                        '"Track your expenses,\nManage your life,\nBuild your future."',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.7,
                          fontWeight: FontWeight.w500,
                          color:
                              isDark ? Colors.white70 : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// 🔥 BOTTOM SECTION

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) {
                            return AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 400,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              width: index == 1 ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  100,
                                ),
                                color: index == 1
                                    ? AppColors.primary
                                    : isDark
                                        ? Colors.white24
                                        : Colors.grey.shade300,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        "SMART EXPENSE TRACKING",
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white54 : Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
