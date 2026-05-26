import 'package:flutter/material.dart';

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

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(

      height: 54,

      decoration: BoxDecoration(

        color: colorScheme.surface,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: colorScheme.outlineVariant,
        ),

        boxShadow: [

          BoxShadow(

            color:
            colorScheme.shadow.withOpacity(
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

        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),

        decoration: InputDecoration(

          hintText:
          "Search food cycles...",

          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
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
            colorScheme.onSurfaceVariant,
          ),

          suffixIcon: InkWell(

            onTap: onFilterTap,

            child: Icon(

              Icons.tune_rounded,

              color:
              colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}