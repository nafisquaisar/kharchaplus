import 'package:flutter/material.dart';

class ElectricitySectionSpacer extends StatelessWidget {
  final double height;

  const ElectricitySectionSpacer({
    super.key,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

