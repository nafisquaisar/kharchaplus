import 'package:flutter/material.dart';

class VerifyButton extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function()? onTap;

  const VerifyButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
          await onTap?.call();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Verify"),
      ),
    );
  }
}