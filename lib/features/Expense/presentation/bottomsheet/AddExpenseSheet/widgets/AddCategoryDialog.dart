

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/KharchaThemeColors.dart';
import '../../../../data/model/category_model.dart';
import '../../../viewmodel/CategoryViewModel.dart';
import 'category_icon.dart';

void showAddCategoryDialog(BuildContext context) {
  final controller = TextEditingController();
  IconData selectedIcon = Icons.category;

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text("Add Category"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Category name",
                ),
              ),
              const SizedBox(height: 12),

              /// 🔥 Icon picker
              Wrap(
                spacing: 10,
                children: categoryIcons.map((icon) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedIcon = icon),
                    child: CircleAvatar(
                      backgroundColor: selectedIcon == icon
                          ? AppColors.primary
                          : AppColors.background,
                      child: Icon(icon,
                          color: selectedIcon == icon
                              ? Colors.white
                              : AppColors.colorText),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final now = DateTime.now();

                final category = CategoryModel(
                  id: now.millisecondsSinceEpoch.toString(),
                  name: controller.text.trim(),
                  icon: selectedIcon.codePoint.toString(),
                  color: AppColors.primary.value,
                  createdAt: now,
                  updatedAt: now,
                );

                context
                    .read<CategoryViewModel>()
                    .addCategory(category);

                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    ),
  );
}