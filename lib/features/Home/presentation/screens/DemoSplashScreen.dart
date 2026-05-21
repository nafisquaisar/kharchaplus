import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DemoSplashScreen extends StatefulWidget {
  const DemoSplashScreen({super.key});

  @override
  State<DemoSplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<DemoSplashScreen> {

  bool animationLoaded = false;

  Future<void> goToHome() async {

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

      body: Container(

        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [

              Color(0xFFD9D9D9),
              Color(0xFFCFCFCF),
              Color(0xFFCBCBCB),

            ],
          ),
        ),

        child: Center(

          child: SizedBox(
            width: 320,
            height: 320,

            child: Lottie.asset(

              'assets/animation/splash3.json',

              fit: BoxFit.contain,

              repeat: false,

              frameRate:
              FrameRate.max,

              onLoaded: (composition) async {

                if (animationLoaded) return;

                animationLoaded = true;

                debugPrint(
                  "Animation Loaded",
                );

                /// Play full animation
                await Future.delayed(
                  composition.duration,
                );

                goToHome();
              },
            ),
          ),
        ),
      ),
    );
  }
}