import 'package:flutter/material.dart';
import '../../../../core/constants/AppColors.dart';
import 'wave_clipper.dart';

class HeaderWave extends StatelessWidget {
  const HeaderWave({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 260,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.kharchaGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 45),
              Image.asset(
                "assets/images/whiteicon1.png",
                height: 100,
              ),
              const SizedBox(height: 5),
              Text(
                "Kharcha Plus",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}