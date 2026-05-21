import 'package:another_flushbar/flushbar.dart';
import 'package:expense_tracker/core/constants/AppColors.dart';
import 'package:flutter/material.dart';

class AppFlushbar {
  static void showSuccess(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: Colors.green.shade600,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  static void showError(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: Colors.red.shade600,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  static void showInfo(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: Colors.black87,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }


  static void showUndo(
      BuildContext context, {
        required String message,
        required VoidCallback onUndo,
      }) {
    late Flushbar flush;

    flush = Flushbar(
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 MESSAGE
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 8),

          /// 🔥 PROGRESS BAR (ANIMATED)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1, end: 0),
            duration: const Duration(seconds: 5),
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 3,
                backgroundColor: Colors.white24,
                valueColor:
                 AlwaysStoppedAnimation<Color>(AppColors.accent),
              );
            },
          ),
        ],
      ),

      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: Colors.black87,
      flushbarPosition: FlushbarPosition.BOTTOM,

      /// 🔥 UNDO BUTTON
      mainButton: TextButton(
        onPressed: () {
          onUndo();
          flush.dismiss();
        },
        child: Text(
          "UNDO",
          style: TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    flush.show(context);
  }

}