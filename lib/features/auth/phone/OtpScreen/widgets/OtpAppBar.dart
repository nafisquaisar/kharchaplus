import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/AppColors.dart';

class OtpAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OtpAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Verify OTP"),
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      // 🔥 Status bar icons white
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),

      // 🔥 THIS IS IMPORTANT (color yaha aayega)
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.kharchaGradient,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}