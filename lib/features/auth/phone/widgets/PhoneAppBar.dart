import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/AppColors.dart';

class PhoneAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PhoneAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: const Text("Phone Login"),

      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: colorScheme.onPrimary,

      // 🔥 THIS LINE IS THE REAL FIX
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),

      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: AppColors.kharchaGradient,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}