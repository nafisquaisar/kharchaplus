import 'package:flutter/material.dart';
import '../../../../../../core/constants/KharchaThemeColors.dart';

class SaveCardButton extends StatelessWidget {
  final bool isEdit;
  final bool isLoading;
  final VoidCallback onPressed;

  const SaveCardButton({
    super.key,
    required this.isEdit,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          isEdit ? "Update Card" : "Create Card",
          style: const TextStyle(fontSize: 16 ,color: AppColors.textPrimary),
        ),
      ),
    );
  }
}