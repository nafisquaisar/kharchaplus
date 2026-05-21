import 'package:expense_tracker/features/auth/phone/widgets/PhoneAppBar.dart';
import 'package:expense_tracker/features/auth/phone/widgets/PhoneHeader.dart';
import 'package:expense_tracker/features/auth/phone/widgets/SendOtpButton.dart';
import 'package:expense_tracker/features/auth/phone/widgets/TrustText.dart';
import 'package:expense_tracker/features/auth/phone/widgets/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/AppColors.dart';
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


    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // Android
          statusBarBrightness: Brightness.dark, // iOS
        ),
        child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PhoneAppBar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
    )
    );
  }
}



