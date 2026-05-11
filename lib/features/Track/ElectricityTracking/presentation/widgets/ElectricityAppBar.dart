import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class ElectricityAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final bool isSyncing;
  final VoidCallback onFilterTap;

  const ElectricityAppBar({
    super.key,
    required this.isSyncing,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {

    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,

      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.kharchaGradient
        ),
      ),

      title: const Text(
        "Electricity Tracking",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),

      iconTheme: const IconThemeData(
        color: Colors.white,
      ),

      actions: [

        if (isSyncing)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ),
          ),

        IconButton(
          onPressed: onFilterTap,
          icon: const Icon(Icons.filter_list),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}