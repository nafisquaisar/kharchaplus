import 'package:flutter/material.dart';

import '../../../../../../../core/constants/AppColors.dart';
import '../../../../../data/model/category_model.dart';

class CategoryDropdown extends StatefulWidget {
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
  State<CategoryDropdown> createState() =>
      _CategoryDropdownState();
}

class _CategoryDropdownState
    extends State<CategoryDropdown> {

  IconData getCategoryIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case "food":
        return Icons.fastfood;

      case "travel":
        return Icons.directions_car;

      case "shopping":
        return Icons.shopping_bag;

      case "health":
        return Icons.health_and_safety;

      case "salary":
        return Icons.account_balance_wallet;

      case "home":
        return Icons.home;

      case "education":
        return Icons.school;

      case "entertainment":
        return Icons.movie;

      case "bills":
        return Icons.receipt_long;

      default:
        return Icons.category;
    }
  }

  void _openCategorySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return _CategoryBottomSheet(
          categories: widget.categories,
          selected: widget.selected,
          onChanged: widget.onChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.selected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            "Category",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _openCategorySheet,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: AppColors.kharchaGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(1),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                children: [
                  if (cat != null) ...[
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color:
                        Color(cat.color).withOpacity(0.12),
                        borderRadius:
                        BorderRadius.circular(9),
                      ),
                      child: Icon(
                        getCategoryIcon(cat.icon),
                        size: 17,
                        color: Color(cat.color),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        cat.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Text(
                        "Select category",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryBottomSheet extends StatefulWidget {
  final List<CategoryModel> categories;
  final CategoryModel? selected;
  final Function(CategoryModel?) onChanged;

  const _CategoryBottomSheet({
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<_CategoryBottomSheet> createState() =>
      _CategoryBottomSheetState();
}

class _CategoryBottomSheetState
    extends State<_CategoryBottomSheet> {

  final TextEditingController searchController =
  TextEditingController();

  List<CategoryModel> filtered = [];

  IconData getCategoryIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case "food":
        return Icons.fastfood;

      case "travel":
        return Icons.directions_car;

      case "shopping":
        return Icons.shopping_bag;

      case "health":
        return Icons.health_and_safety;

      case "salary":
        return Icons.account_balance_wallet;

      case "home":
        return Icons.home;

      case "education":
        return Icons.school;

      case "entertainment":
        return Icons.movie;

      case "bills":
        return Icons.receipt_long;

      default:
        return Icons.category;
    }
  }

  @override
  void initState() {
    super.initState();
    filtered = widget.categories;
  }

  void _search(String value) {
    setState(() {
      filtered = widget.categories.where((e) {
        return e.name
            .toLowerCase()
            .contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .60,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      child: Column(
        children: [

          Container(
            height: 4,
            width: 50,
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: searchController,
              onChanged: _search,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search category",
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 10),
              itemBuilder: (_, index) {

                final cat = filtered[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    widget.onChanged(cat);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                      widget.selected?.id == cat.id
                          ? Color(cat.color)
                          .withOpacity(.08)
                          : Colors.white,
                      borderRadius:
                      BorderRadius.circular(14),
                      border: Border.all(
                        color:
                        widget.selected?.id ==
                            cat.id
                            ? Color(cat.color)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [

                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: Color(cat.color)
                                .withOpacity(.12),
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                          child: Icon(
                            getCategoryIcon(cat.icon),
                            color: Color(cat.color),
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Text(
                            cat.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),

                        if (widget.selected?.id ==
                            cat.id)
                          Icon(
                            Icons.check_circle_rounded,
                            color: Color(cat.color),
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}