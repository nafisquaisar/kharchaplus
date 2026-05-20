import 'dart:math';
import 'package:flutter/material.dart';

import '../constants/AppColors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> leftCurveAnim;
  late Animation<double> rightCurveAnim;

  late Animation<double> dropAnim;

  late Animation<double> rupeeFade;

  late Animation<double> plusScale;

  late Animation<double> spoonRotate;

  late Animation<double> glowAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 3500,
      ),
    );

    /// Water drop
    dropAnim = Tween<double>(
      begin: -180,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.25,
          curve: Curves.bounceOut,
        ),
      ),
    );

    /// Left infinity curve
    leftCurveAnim = Tween<double>(
      begin: -140,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.20,
          0.45,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    /// Right infinity curve
    rightCurveAnim = Tween<double>(
      begin: 140,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.20,
          0.45,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    /// Rupee fade
    rupeeFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.45,
          0.60,
          curve: Curves.easeIn,
        ),
      ),
    );

    /// Plus pop
    plusScale = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.60,
          0.75,
          curve: Curves.elasticOut,
        ),
      ),
    );

    /// Spoon rotation
    spoonRotate = Tween<double>(
      begin: -1.5,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.55,
          0.80,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    /// Glow pulse
    glowAnim = Tween<double>(
      begin: 0,
      end: 25,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.75,
          1,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _controller.forward();

    /// Navigate after splash
    Future.delayed(
      const Duration(seconds: 4),
          () {

        /// TODO:
        /// Navigate to home screen
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildGlow() {

    return AnimatedBuilder(
      animation: glowAnim,

      builder: (_, child) {

        return Container(
          width: 180,
          height: 180,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            boxShadow: [

              BoxShadow(
                color: AppColors.accent
                    .withOpacity(0.25),

                blurRadius:
                glowAnim.value,

                spreadRadius: 6,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      AppColors.background,

      body: Center(
        child: SizedBox(
          width: 260,
          height: 260,

          child: Stack(
            alignment: Alignment.center,

            children: [

              /// Glow
              buildGlow(),

              /// LEFT CURVE
              AnimatedBuilder(
                animation: leftCurveAnim,
                builder: (_, child) {

                  return Positioned(
                    left: leftCurveAnim.value,
                    top: 58,

                    child: Image.asset(
                      'assets/logo/left_curve.png',
                      width: 122,
                    ),
                  );
                },
              ),

              /// RIGHT CURVE
              AnimatedBuilder(
                animation: rightCurveAnim,
                builder: (_, child) {

                  return Positioned(
                    right: rightCurveAnim.value,
                    top: 58,

                    child: Image.asset(
                      'assets/logo/right_curve.png',
                      width: 122,
                    ),
                  );
                },
              ),

              /// WATER DROP
              AnimatedBuilder(
                animation: dropAnim,
                builder: (_, child) {

                  return Positioned(
                    top: dropAnim.value + 18,

                    child: Image.asset(
                      'assets/logo/drop.png',
                      width: 36,
                    ),
                  );
                },
              ),

              /// RUPEE
              FadeTransition(
                opacity: rupeeFade,

                child: Positioned(
                  left: 88,
                  top: 110,

                  child: Image.asset(
                    'assets/logo/rupee.png',
                    width: 28,
                  ),
                ),
              ),

              /// SPOON
              AnimatedBuilder(
                animation: spoonRotate,
                builder: (_, child) {

                  return Positioned(
                    right: 82,
                    top: 102,

                    child: Transform.rotate(
                      angle: spoonRotate.value,

                      child: Image.asset(
                        'assets/logo/spoon.png',
                        width: 28,
                      ),
                    ),
                  );
                },
              ),

              /// PLUS
              ScaleTransition(
                scale: plusScale,

                child: Positioned(
                  bottom: 52,
                  child: Container(
                    width: 26,
                    height: 26,

                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius:
                      BorderRadius.circular(8),
                    ),

                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 18,
                    ),
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