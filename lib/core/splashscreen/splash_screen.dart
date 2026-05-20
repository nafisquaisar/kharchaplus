import 'package:flutter/material.dart';

import '../constants/AppColors.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController
  _controller;

  late Animation<double>
  _scaleAnimation;

  late Animation<double>
  _fadeAnimation;

  late Animation<double>
  _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1800,
      ),
    );

    /// ✅ Smooth scale
    _scaleAnimation =
        Tween<double>(
          begin: 0.6,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
          ),
        );

    /// ✅ Fade animation
    _fadeAnimation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeIn,
          ),
        );

    /// ✅ Slight rotation effect
    _rotationAnimation =
        Tween<double>(
          begin: -0.08,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      AppColors.background,

      body: Center(
        child: AnimatedBuilder(
          animation: _controller,

          builder: (
              context,
              child,
              ) {

            return Opacity(
              opacity:
              _fadeAnimation.value,

              child: Transform.rotate(
                angle:
                _rotationAnimation
                    .value,

                child: Transform.scale(
                  scale:
                  _scaleAnimation
                      .value,

                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      /// ✅ Logo
                      Container(
                        padding:
                        const EdgeInsets.all(
                          18,
                        ),

                        decoration:
                        BoxDecoration(
                          shape:
                          BoxShape.circle,

                          boxShadow: [

                            BoxShadow(
                              color: AppColors
                                  .accent
                                  .withOpacity(
                                0.18,
                              ),

                              blurRadius:
                              35,

                              spreadRadius:
                              8,
                            ),
                          ],
                        ),

                        child: Image.asset(
                          'assets/logo/logo2.png',

                          height: 120,
                        ),
                      ),

                      const SizedBox(
                        height: 22,
                      ),

                      /// ✅ App Name
                      ShaderMask(
                        shaderCallback:
                            (bounds) {

                          return LinearGradient(
                            colors: [
                              AppColors.accent,
                              Colors.teal,
                            ],
                          ).createShader(
                            bounds,
                          );
                        },

                        child: const Text(
                          'Kharcha Plus',

                          style: TextStyle(
                            fontSize: 30,

                            fontWeight:
                            FontWeight.bold,

                            color: Colors.white,

                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      /// ✅ Tagline
                      Text(
                        'Track Smart • Save Better',

                        style: TextStyle(
                          fontSize: 14,

                          color: AppColors
                              .textSecondary,

                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}