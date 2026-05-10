import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedCode;
  final Function(String) onCodeChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    required this.selectedCode,
    required this.onCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          /// 🌍 COUNTRY DROPDOWN (IMPROVED)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCode,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Colors.grey,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                items: const [
                  DropdownMenuItem(
                    value: "+91",
                    child: Text("🇮🇳 +91"),
                  ),
                  DropdownMenuItem(
                    value: "+1",
                    child: Text("🇺🇸 +1"),
                  ),
                  DropdownMenuItem(
                    value: "+44",
                    child: Text("🇬🇧 +44"),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) onCodeChanged(val);
                },
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// Divider
          Container(
            height: 28,
            width: 1,
            color: Colors.grey.shade300,
          ),

          const SizedBox(width: 10),

          /// 📱 Phone Input
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: "Enter phone number",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}