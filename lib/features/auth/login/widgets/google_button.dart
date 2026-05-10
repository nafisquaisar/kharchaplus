import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/AppColors.dart';
import '../../../../core/constants/colors.dart';
import '../../viewmodel/auth_viewmodel.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: vm.isLoading
          ? null
          : () async {
        final success = await vm.signInWithGoogle();

        if (!success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(vm.errorMessage ?? "Login failed")),
          );
        }
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.kharchaGradient,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: vm.isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.textPrimary,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔥 Google Icon
              Image.asset(
                "assets/images/google.png",
                height: 20,
              ),
              const SizedBox(width: 10),

              const Text(
                "Sign in with Google",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}