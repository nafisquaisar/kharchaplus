/// 📄 CategoryCard.dart

import 'package:flutter/material.dart';

import '../../../../../../core/constants/KharchaThemeColors.dart';
import '../../../../data/model/category_model.dart';
import 'CategoryCard/AddCategoryDialog.dart';
import 'CategoryCard/CategoryDropdown.dart';

class CategoryCard extends StatelessWidget {
  final List<CategoryModel> categories;
  final CategoryModel? selected;

  final Function(CategoryModel?) onChanged;

  const CategoryCard({
    super.key,
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [

          /// 📂 Category Dropdown
          CategoryDropdown(
            categories: categories,
            selected: selected,
            onChanged: onChanged,
          ),

          const SizedBox(height: 4),

          /// ➕ Add Category
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
              ),

              onPressed: () =>
                  showAddCategoryBottomSheet(context),

              icon: const Icon(
                Icons.add_circle_outline_rounded,
                size: 18,
              ),

              label: const Text(
                "Add Category",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}