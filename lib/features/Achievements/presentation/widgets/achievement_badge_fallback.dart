import 'package:flutter/material.dart';

/// Minimal fallback badge when an SVG asset fails to load.
/// Keeps layout stable without showing placeholder text.
class AchievementBadgeFallback extends StatelessWidget {
  final double size;

  const AchievementBadgeFallback({Key? key, this.size = 48}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(size * 0.18),
        border: Border.all(color: Colors.black.withAlpha(18)),
      ),
    );
  }
}
