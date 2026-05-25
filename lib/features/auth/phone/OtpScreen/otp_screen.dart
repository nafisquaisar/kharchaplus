import 'package:expense_tracker/features/auth/phone/OtpScreen/widgets/OtpAppBar.dart';
import 'package:expense_tracker/features/auth/phone/OtpScreen/widgets/OtpHeader.dart';
import 'package:expense_tracker/features/auth/phone/OtpScreen/widgets/OtpInputField.dart';
import 'package:expense_tracker/features/auth/phone/OtpScreen/widgets/ResendSection.dart';
import 'package:expense_tracker/features/auth/phone/OtpScreen/widgets/VerifyButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/auth_viewmodel.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final bool isLinking;

  const OtpScreen({
    super.key,
    required this.phone,
    this.isLinking = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}



class _OtpScreenState extends State<OtpScreen> {
  String otp = "";
  String? otpError;


  String getOtpErrorMessage(String? error) {
    if (error == null) return "Something went wrong";

    if (error.contains("invalid-verification-code")) {
      return "Invalid OTP. Please try again.";
    }

    if (error.contains("session-expired")) {
      return "OTP expired. Request a new one.";
    }

    if (error.contains("too-many-requests")) {
      return "Too many attempts. Try again later.";
    }

    return "Verification failed. Please try again.";
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const OtpAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Header
            OtpHeader(phone: widget.phone),

            const SizedBox(height: 30),

            /// 🔹 OTP Input
            OtpInputField(
              onCompleted: (value) {
                setState(() {
                  otp = value;
                  otpError = null; // 🔥 clear error when typing
                });
              },
            ),

            /// 🔴 Error Message
            if (otpError != null) ...[
              const SizedBox(height: 10),
              Text(
                otpError!,
                style: TextStyle(
                  color: colorScheme.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],

            const SizedBox(height: 25),

            /// 🔹 Verify Button
            VerifyButton(
              isLoading: vm.isLoading,
              onTap: otp.length == 6
                  ? () async {
                final success = widget.isLinking
                    ? await vm.linkPhone(otp)
                    : await vm.verifyOtp(otp);

                if (!context.mounted) return;

                if (success) {
                  Navigator.popUntil(
                      context, (route) => route.isFirst);
                } else {
                  setState(() {
                    otpError = getOtpErrorMessage(vm.errorMessage);
                  });
                }
              }
                  : null, // 🔥 disable if incomplete
            ),

            const SizedBox(height: 20),

            /// 🔹 Resend
            ResendSection(vm: vm),
          ],
        ),
      ),
    );
  }
}