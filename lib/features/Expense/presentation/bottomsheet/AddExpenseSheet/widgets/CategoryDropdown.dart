import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/KharchaThemeColors.dart';
import '../../../../data/model/category_model.dart';

class CategoryDropdown extends StatelessWidget {
  final List<CategoryModel> categories;
  final CategoryModel? selected;
  final Function(CategoryModel?) onChanged;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CategoryModel>(
      value: selected,
      decoration: _input(),
      items: categories.map((cat) {
        return DropdownMenuItem(
          value: cat,
          child: Row(
            children: [
              Icon(
                Icons.category, // default icon
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(cat.name),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  InputDecoration _input() => InputDecoration(
    filled: true,
    fillColor: AppColors.background,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );
}