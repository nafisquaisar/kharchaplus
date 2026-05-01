import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'otp_screen.dart';

class PhoneScreen extends StatefulWidget {
  final bool isLinking;

  const PhoneScreen({super.key, this.isLinking = false});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final phoneCtrl = TextEditingController();

  @override
  void dispose() {
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.isLinking ? "Link Phone" : "Phone Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 TITLE
            const Text(
              "Enter Phone Number",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "We will send you an OTP",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 30),

            /// 📱 PHONE FIELD
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "+91 9876543210",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 SEND OTP BUTTON
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
                        final rawPhone = phoneCtrl.text.trim();
                        final phone = rawPhone.replaceAll(' ', '');
                        final e164 = RegExp(r'^\+\d{8,15}$');

                        if (!phone.startsWith('+')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Include country code, e.g. +91 9876543210',
                              ),
                            ),
                          );
                          return;
                        }

                        if (!e164.hasMatch(phone)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Enter a valid E.164 phone number'),
                            ),
                          );
                          return;
                        }

                        final result = widget.isLinking
                            ? await vm.sendOtpForLink(phone)
                            : await vm.sendOtp(phone);
                        if (!context.mounted) {
                          return;
                        }

                        if (result == OtpSendStatus.autoVerified) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          return;
                        }

                        if (result == OtpSendStatus.codeSent) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OtpScreen(
                                phone: phone,
                                isLinking: widget.isLinking,
                              ),
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(vm.errorMessage ?? 'OTP send failed'),
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
                  "Send OTP",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}