import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/constants/KharchaThemeColors.dart';
import '../../../../../../../core/utils/AppFlushbar.dart';
import '../../../../../data/model/category_model.dart';
import '../../../../viewmodel/CategoryViewModel.dart';
import 'category_icon.dart';

void showAddCategoryBottomSheet(BuildContext context) {
  final controller = TextEditingController();

  Map<String, dynamic> selectedItem = customCategoryIcons.first;

  List<Map<String, dynamic>> filteredIcons = List.from(customCategoryIcons);

  showModalBottomSheet(
    context: context,

    isScrollControlled: true,

    useSafeArea: true,

    backgroundColor: Colors.transparent,

    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.85,

            minChildSize: 0.65,

            maxChildSize: 0.96,

            expand: false,

            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 14,

                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),

                decoration: const BoxDecoration(
                  color: AppColors.primarybg,

                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),

                child: SingleChildScrollView(
                  controller: scrollController,

                  physics: const BouncingScrollPhysics(),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// 🔥 Handle
                      Center(
                        child: Container(
                          height: 5,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// 🔥 Header
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Add Category",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.colorText,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },

                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: const Icon(Icons.close_rounded, color: Colors.red ,size: 22),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 🔥 Search Category
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(.1),
                              blurRadius: 12,
                              spreadRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),

                        child: TextField(
                          controller: controller,

                          onChanged: (value) {
                            setState(() {
                              filteredIcons = customCategoryIcons.where((item) {
                                return item["name"]
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase());
                              }).toList();

                              /// 🔥 Auto Select
                              if (filteredIcons.isNotEmpty) {
                                selectedItem = filteredIcons.first;
                              }
                            });
                          },

                          decoration: InputDecoration(
                            hintText: "Search category icon",

                            prefixIcon: const Icon(Icons.search_rounded),

                            filled: true,

                            fillColor: Colors.white,

                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),

                              borderSide: BorderSide.none,
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),

                              borderSide: BorderSide.none,
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),

                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      /// 🔥 Preview
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 10),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.09),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: selectedItem["color"],

                              child: Icon(
                                selectedItem["icon"],
                                color: Colors.white,
                                size: 20,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                    "Preview",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 2),

                                  Text(
                                    controller.text.trim().isEmpty
                                        ? selectedItem["name"]
                                        : controller.text.trim(),

                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.colorText,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            GestureDetector(
                              onTap: () async {
                                final name = controller.text.trim();

                                if (name.isEmpty) {
                                  AppFlushbar.showError(
                                    context,
                                    "Enter category name",
                                  );
                                  return;
                                }

                                try {
                                  final now = DateTime.now();

                                  final category = CategoryModel(
                                    id: now.millisecondsSinceEpoch.toString(),

                                    name: name,

                                    icon: (selectedItem["icon"] as IconData)
                                        .codePoint
                                        .toString(),

                                    color:
                                    (selectedItem["color"] as Color).value,

                                    createdAt: now,

                                    updatedAt: now,
                                  );

                                  await context
                                      .read<CategoryViewModel>()
                                      .addCategory(category);

                                  if (!context.mounted) {
                                    return;
                                  }

                                  Navigator.pop(context);

                                  AppFlushbar.showSuccess(
                                    context,
                                    "Category Added",
                                  );
                                } catch (e) {
                                  AppFlushbar.showError(context, e.toString());
                                }
                              },

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),

                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(8),
                                ),

                                child: const Text(
                                  "Add",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// 🔥 Choose Icon
                      const Text(
                        "Choose Icon",

                        style: TextStyle(
                          fontSize: 17,

                          fontWeight: FontWeight.w700,

                          color: AppColors.colorText,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 🔥 Grid
                      GridView.builder(
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: filteredIcons.length,

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,

                              crossAxisSpacing: 12,

                              mainAxisSpacing: 12,

                              mainAxisExtent: 90,
                            ),

                        itemBuilder: (context, index) {
                          final item = filteredIcons[index];

                          final isSelected = selectedItem == item;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedItem = item;

                                controller.text = item["name"];
                              });
                            },

                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),

                              padding: const EdgeInsets.all(8),

                              decoration: BoxDecoration(
                                color: isSelected
                                    ? item["color"]
                                    : Colors.white,

                                borderRadius: BorderRadius.circular(20),

                                border: Border.all(
                                  color: isSelected
                                      ? item["color"]
                                      : Colors.grey.shade300,
                                ),

                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: item["color"].withOpacity(.35),
                                      blurRadius: 12,
                                      offset: const Offset(0, 5),
                                    ),
                                ],
                              ),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  Icon(
                                    item["icon"],

                                    color: isSelected
                                        ? Colors.white
                                        : item["color"],

                                    size: 25,
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    item["name"],

                                    maxLines: 1,

                                    overflow: TextOverflow.ellipsis,

                                    textAlign: TextAlign.center,

                                    style: TextStyle(
                                      fontSize: 10,

                                      fontWeight: FontWeight.w600,

                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.colorText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}
