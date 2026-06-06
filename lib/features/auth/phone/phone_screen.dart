import 'package:expense_tracker/features/auth/phone/widgets/PhoneAppBar.dart';
import 'package:expense_tracker/features/auth/phone/widgets/PhoneHeader.dart';
import 'package:expense_tracker/features/auth/phone/widgets/SendOtpButton.dart';
import 'package:expense_tracker/features/auth/phone/widgets/TrustText.dart';
import 'package:expense_tracker/features/auth/phone/widgets/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_viewmodel.dart';
import 'OtpScreen/otp_screen.dart';

class PhoneScreen extends StatefulWidget {
  final bool isLinking;

  const PhoneScreen({super.key, this.isLinking = false});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final phoneCtrl = TextEditingController();
  String selectedCode = "+91";

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PhoneAppBar(),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = 520.0;
            final horizontalPadding =
                (constraints.maxWidth * 0.06).clamp(16.0, 24.0).toDouble();

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    viewInsets.bottom + 24,
                  ),
                  child: Column(
                    children: [
                      const PhoneHeader(),

                      const SizedBox(height: 30),

                      PhoneInputField(
                        controller: phoneCtrl,
                        selectedCode: selectedCode,
                        onCodeChanged: (code) {
                          setState(() => selectedCode = code);
                        },
                      ),

                      const SizedBox(height: 20),

                      SendOtpButton(
                        isLoading: vm.isLoading,
                        onTap: () async {
                          final phone = "$selectedCode${phoneCtrl.text.trim()}";

                          final result = widget.isLinking
                              ? await vm.sendOtpForLink(phone)
                              : await vm.sendOtp(phone);

                          if (!context.mounted) return;

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
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      const TrustText(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    )
    );
  }
}

