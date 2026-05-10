import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class TransactionHeader extends StatelessWidget {
  final VoidCallback onAdd;

  const TransactionHeader({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        /// 🔥 TITLE
        Text(
          "Transactions",
          style: TextStyle(
            fontSize: width * 0.042,
            fontWeight: FontWeight.w600,
          ),
        ),

        /// 🔥 ROUND ADD BUTTON (MINIMAL)
        InkWell(
          onTap: onAdd,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}