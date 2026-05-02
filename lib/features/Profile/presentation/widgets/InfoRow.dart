import 'package:flutter/cupertino.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final dynamic value;

  const InfoRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text("$value"),
        ],
      ),
    );
  }
}