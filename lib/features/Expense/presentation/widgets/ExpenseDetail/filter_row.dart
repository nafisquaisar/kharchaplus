import 'package:flutter/material.dart';

import '../../../../../core/constants/KharchaThemeColors.dart';
import '../../../data/model/ExpenseModel.dart';

class FilterRow extends StatelessWidget {
  final ExpenseType? selectedType;

  final Function(ExpenseType?)
  onChanged;
  final VoidCallback onFilterTap;
  final VoidCallback onAddTap; // ✅ NEW

  const FilterRow({
    super.key,
    required this.onChanged,
    required this.onFilterTap,
    required this.onAddTap,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        /// 🔥 CHIPS
        Expanded(
          child: SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _chip(
                  label: "All",
                  type: null,
                ),
                const SizedBox(width: 8),

                _chip(
                  label: "Expense",
                  type: ExpenseType.expense,
                ),
                const SizedBox(width: 8),

                _chip(
                  label: "Income",
                  type: ExpenseType.income,
                ),

              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        /// 🔥 FILTER ICON
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.tune, size: 18),
          ),
        ),

        const SizedBox(width: 8),

        /// 🔥 ADD BUTTON (IMPORTANT)
        GestureDetector(
          onTap: onAddTap, // ✅ THIS WAS MISSING
          child: Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 18),
          ),
        ),

      ],
    );
  }

  Widget _chip({

    required String label,

    required ExpenseType? type,
  }) {

    final isSelected =
        selectedType == type;

    return GestureDetector(

      onTap: () => onChanged(type),

      child: Container(

        padding:
        const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),

        decoration: BoxDecoration(

          color: isSelected
              ? AppColors.accent
              : Colors.white,

          borderRadius:
          BorderRadius.circular(18),

          border: Border.all(

            color: isSelected
                ? AppColors.accent
                : Colors.grey.shade300,
          ),
        ),

        child: Center(
          child: Text(

            label,

            style: TextStyle(

              fontSize: 13,

              fontWeight:
              FontWeight.w500,

              color: isSelected
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}