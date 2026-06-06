import 'package:flutter/material.dart';
import '../../../../core/constants/AppColors.dart';
import 'wave_clipper.dart';

class HeaderWave extends StatelessWidget {
  const HeaderWave({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final headerHeight = (height * 0.28).clamp(200.0, 280.0).toDouble();
    final logoSize = (height * 0.12).clamp(70.0, 110.0).toDouble();

    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: headerHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.kharchaGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: (headerHeight * 0.18).clamp(24.0, 48.0)),
              Image.asset(
                "assets/images/whiteicon1.png",
                height: logoSize,
              ),
              const SizedBox(height: 6),
              const Text(
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