import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class AuthDebugDiagnostics {
  static Future<void> logStartup() async {
    if (!kDebugMode) return;

    final app = Firebase.app();
    final options = app.options;
    final platform = kIsWeb ? 'web' : defaultTargetPlatform.name;

    debugPrint('[AuthDiag] platform=$platform');
    debugPrint('[AuthDiag] appName=${app.name} projectId=${options.projectId}');
    debugPrint('[AuthDiag] appId=${options.appId} apiKey=${_mask(options.apiKey)}');

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      if ((options.iosClientId ?? '').isEmpty) {
        debugPrint('[AuthDiag][iOS] Missing iosClientId.');
        debugPrint(
          '[AuthDiag][iOS] Fix: add ios/Runner/GoogleService-Info.plist and URL scheme for REVERSED_CLIENT_ID.',
        );
        debugPrint(
          '[AuthDiag][iOS] If not fixed: Google sign-in fails with sign_in_failed or missing-client-identifier.',
        );
      }
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      debugPrint(
        '[AuthDiag][Android] Verify debug+release SHA-1/SHA-256 in Firebase Console for package ${options.projectId}.',
      );
      debugPrint(
        '[AuthDiag][Android] If not fixed: Google sign-in fails with ApiException: 10 or sign_in_failed.',
      );
    }

    final auth = FirebaseAuth.instance;
    debugPrint('[AuthDiag] authApp=${auth.app.name} currentUser=${auth.currentUser?.uid ?? 'none'}');
  }

  static String _mask(String? value) {
    if (value == null || value.length < 6) return 'n/a';
    return '${value.substring(0, 3)}...${value.substring(value.length - 3)}';
  }
}

