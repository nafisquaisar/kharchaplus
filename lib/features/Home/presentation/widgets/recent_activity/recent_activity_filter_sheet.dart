import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class RecentActivityFilterSheet extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const RecentActivityFilterSheet({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 50,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Filter Activity',
            style: textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...options.map((option) {
            final isSelected = option == selected;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                option,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              trailing: isSelected
                  ?  Icon(Icons.check_circle_rounded, color: AppColors.accent)
                  :  Icon(
                      Icons.radio_button_unchecked_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
              onTap: () {
                onSelected(option);
              },
            );
          }),
        ],
      ),
    );
  }
}

