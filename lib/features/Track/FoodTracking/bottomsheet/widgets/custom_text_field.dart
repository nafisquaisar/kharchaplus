import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController controller;

  final String hint;

  final IconData icon;

  final TextInputType keyboardType;

  final int maxLines;

  final String? suffixText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      height: maxLines == 1 ? 48 : null,

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(10),

        border: Border.all(
          color: AppColors.primary,
          width: 1,
        ),

        boxShadow: [

          BoxShadow(

            color: AppColors.primary
                .withOpacity(0.06),

            blurRadius: 6,

            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      ),

      child: TextField(

        controller: controller,

        keyboardType: keyboardType,

        maxLines: maxLines,

        style: const TextStyle(

          fontSize: 14,

          fontWeight: FontWeight.w500,

          color: Colors.black,
        ),

        decoration: InputDecoration(

          hintText: hint,

          hintStyle: TextStyle(

            color: Colors.grey.shade400,

            fontWeight: FontWeight.w500,

            fontSize: 13,
          ),

          border: InputBorder.none,

          isDense: true,

          contentPadding:
          const EdgeInsets.symmetric(

            vertical: 12,

            horizontal: 12,
          ),

          // PREFIX ICON

          prefixIcon: Padding(

            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),

            child: Container(

              margin:
              const EdgeInsets.symmetric(
                vertical: 6,
              ),

              width: 34,

              decoration: BoxDecoration(

                color:
                AppColors.primarybg,

                borderRadius:
                BorderRadius.circular(
                  10,
                ),
              ),

              child: Icon(

                icon,

                color:
                AppColors.primary,

                size: 18,
              ),
            ),
          ),

          prefixIconConstraints:
          const BoxConstraints(
            minWidth: 56,
          ),

          // SUFFIX

          suffixText: suffixText,

          suffixStyle: TextStyle(

            color: Colors.grey.shade500,

            fontWeight: FontWeight.w600,

            fontSize: 12,
          ),
        ),
      ),
    );
  }
}