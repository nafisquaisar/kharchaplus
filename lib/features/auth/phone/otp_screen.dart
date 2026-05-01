import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_viewmodel.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final bool isLinking;

  const OtpScreen({super.key, required this.phone, this.isLinking = false});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpCtrl = TextEditingController();

  @override
  void dispose() {
    otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 TITLE
            const Text(
              "Enter OTP",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "OTP sent to ${widget.phone}",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 30),

            /// 🔐 OTP FIELD
            TextField(
              controller: otpCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: "Enter 6-digit OTP",
                counterText: "",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 VERIFY BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: vm.isLoading
                    ? null
                    : () async {
                        final otp = otpCtrl.text.trim();
                        final success = widget.isLinking
                            ? await vm.linkPhone(otp)
                            : await vm.verifyOtp(otp);

                        if (!context.mounted) {
                          return;
                        }

                        if (success) {
                          Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              vm.errorMessage ??
                                  (widget.isLinking
                                      ? "Phone linking failed"
                                      : "OTP verification failed"),
                            ),
                            action: SnackBarAction(
                              label: 'Retry',
                              onPressed: () {
                                if (!vm.isLoading) {
                                  if (widget.isLinking) {
                                    vm.linkPhone(otp);
                                  } else {
                                    vm.verifyOtp(otp);
                                  }
                                }
                              },
                            ),
                          ),
                        );
                      },
                child: vm.isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  "Verify",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔁 RESEND
            Center(
              child: TextButton(
                onPressed: vm.canResendOtp
                    ? () async {
                        final result = await vm.resendOtp();
                        if (!context.mounted) {
                          return;
                        }
                        if (result == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                vm.errorMessage ?? 'OTP resend failed',
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                child: Text(
                  vm.canResendOtp
                      ? "Resend OTP"
                      : "Resend in ${vm.resendSecondsRemaining}s",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}