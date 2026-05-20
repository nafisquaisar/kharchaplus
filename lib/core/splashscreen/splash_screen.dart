  import 'package:flutter/material.dart';
  import 'package:lottie/lottie.dart';

  import '../constants/AppColors.dart';

  class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() =>
        _SplashScreenState();
  }

  class _SplashScreenState
      extends State<SplashScreen> {

    @override
    void initState() {
      super.initState();

      goToHome();
    }

    Future<void> goToHome() async {

      /// Match animation duration
      await Future.delayed(
        const Duration(seconds: 2),
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        '/home',
      );
    }

    @override
    Widget build(BuildContext context) {

      return Scaffold(

        backgroundColor:
        AppColors.splashBackground,

        body: Container(

          width: double.infinity,
          height: double.infinity,

          decoration: const BoxDecoration(

            gradient: LinearGradient(

              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,

              colors: [

                Color(0xFF0F151E),
                Color(0xFF102530),
                Color(0xFF0E2E3D),

              ],
            ),
          ),

          child: Center(

            child: SizedBox(
              width: 300,
              height: 300,

              child: Lottie.asset(

                'assets/animation/splash.json',

                fit: BoxFit.contain,

                repeat: false,

                frameRate:
                FrameRate.max,
              ),
            ),
          ),
        ),
      );
    }
  }