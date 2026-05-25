import 'package:flutter/material.dart';
import '../../../viewmodel/auth_viewmodel.dart';

class ResendSection extends StatelessWidget {
  final AuthViewModel vm;

  const ResendSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final canResend = vm.canResendOtp;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// 🔥 Resend Button
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: canResend
                ? () async {
              final result = await vm.resendOtp();

              if (!context.mounted) return;

              if (result == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        vm.errorMessage ?? "Resend failed"),
                  ),
                );
              }
            }
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 6),
              child: Text(
                "Resend OTP",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: canResend
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          /// 🔥 Space
          if (!canResend) const SizedBox(width: 10),

          /// 🔥 Timer
          if (!canResend)
            Text(
              "in ${vm.resendSecondsRemaining}s",
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}