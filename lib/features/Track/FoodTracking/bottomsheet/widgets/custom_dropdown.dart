import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class CustomDropdown
    extends StatelessWidget {

  final String value;

  final List<String> items;

  final Function(String?)
  onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      height: 48,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
      ),

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

            color:
            AppColors.primary
                .withOpacity(0.06),

            blurRadius: 6,

            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      ),

      child:
      DropdownButtonHideUnderline(

        child: DropdownButton<String>(

          value: value,

          isExpanded: true,

          icon: Icon(

            Icons.keyboard_arrow_down,

            color:
            Colors.grey.shade500,

            size: 20,
          ),

          style: const TextStyle(

            fontSize: 14,

            fontWeight:
            FontWeight.w600,

            color: Colors.black,
          ),

          items:
          items.map((e) {

            return DropdownMenuItem(

              value: e,

              child: Text(e),
            );
          }).toList(),

          onChanged: onChanged,
        ),
      ),
    );
  }
}