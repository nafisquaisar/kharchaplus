import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpInputField extends StatefulWidget {
  final Function(String) onCompleted;

  const OtpInputField({super.key, required this.onCompleted});

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField>
    with CodeAutoFill {
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    listenForCode(); // 🔥 SMS autofill
  }

  @override
  void dispose() {
    cancel();
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  /// 🔥 SMS Auto Fill
  @override
  void codeUpdated() {
    if (code != null && code!.length == 6) {
      for (int i = 0; i < 6; i++) {
        controllers[i].text = code![i];
      }
      _checkAndSubmitOtp();
      FocusScope.of(context).unfocus();
    }
  }

  void _onChanged(String value, int index) {

    if (value.length >= 6) {
      for (int i = 0; i < 6; i++) {
        controllers[i].text = value[i];
      }

      _checkAndSubmitOtp();
      FocusScope.of(context).unfocus();
      return;
    }

    // /// 🔥 Full paste support
    // if (value.length > 1) {
    //   for (int i = 0; i < 6; i++) {
    //     controllers[i].text = value.length > i ? value[i] : "";
    //   }
    //   _checkAndSubmitOtp();
    //   FocusScope.of(context).unfocus();
    //   return;
    // }

    /// ➡️ Forward
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
      setState(() {});
    }

    /// ⬅️ Backward
    else {
      if (index > 0) {
        controllers[index - 1].clear();
        focusNodes[index - 1].requestFocus();
      }
    }

    setState(() {}); // 🔥 animation trigger

    _checkAndSubmitOtp();
  }


  void _checkAndSubmitOtp() {
    String otp = controllers.map((e) => e.text).join();

    if (otp.length == 6 && !controllers.any((c) => c.text.isEmpty)){
      FocusScope.of(context).unfocus();
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        double totalWidth = constraints.maxWidth;
        double boxWidth = (totalWidth - 60) / 6;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            bool isFocused = focusNodes[index].hasFocus;

            return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: boxWidth.clamp(45, 60),
                height: 55,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    width: isFocused ? 2 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isFocused
                          ? colorScheme.primary.withOpacity(0.2)
                          : colorScheme.shadow.withOpacity(0.05),
                      blurRadius: isFocused ? 10 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.backspace) {

                      if (controllers[index].text.isEmpty && index > 0) {
                        controllers[index - 1].clear();
                        focusNodes[index - 1].requestFocus();
                        setState(() {});
                        return KeyEventResult.handled;
                      }

                      return KeyEventResult.ignored;
                    }

                    return KeyEventResult.ignored;
                  },
                  child: TextField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    autofillHints: const [AutofillHints.oneTimeCode],

                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),

                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                    ),

                    onChanged: (value) => _onChanged(value, index),
                  ),
                )
            );
          }),
        );
      },
    );
  }
}