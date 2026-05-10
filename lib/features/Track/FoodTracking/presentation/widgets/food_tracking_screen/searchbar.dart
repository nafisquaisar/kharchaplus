import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

class SearchBarWidget
    extends StatelessWidget {

  final TextEditingController?
  controller;

  final Function(String)?
  onChanged;

  final VoidCallback?
  onFilterTap;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      height: 54,

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: AppColors.border,
        ),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withOpacity(
              0.04,
            ),

            blurRadius: 8,

            offset: const Offset(
              0,
              3,
            ),
          ),
        ],
      ),

      child: TextField(

        controller: controller,

        onChanged: onChanged,

        decoration: InputDecoration(

          hintText:
          "Search food cycles...",

          hintStyle: TextStyle(

            color:
            Colors.grey.shade500,

            fontSize: 14,
          ),

          border: InputBorder.none,

          contentPadding:
          const EdgeInsets.symmetric(
            vertical: 15,
          ),

          prefixIcon: Icon(

            Icons.search_rounded,

            color:
            Colors.grey.shade500,
          ),

          suffixIcon: InkWell(

            onTap: onFilterTap,

            child: Icon(

              Icons.tune_rounded,

              color:
              Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }
}