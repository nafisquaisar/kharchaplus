import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class AuthLogger {
  final FirebaseAnalytics? _analytics;
  final FirebaseCrashlytics? _crashlytics;

  const AuthLogger({
    FirebaseAnalytics? analytics,
    FirebaseCrashlytics? crashlytics,
  })  : _analytics = analytics,
        _crashlytics = crashlytics;

  Future<void> logLoginSuccess(String provider) async {
    debugPrint('[Auth] Login success via $provider');
    await _analytics?.logLogin(loginMethod: provider);
  }

  Future<void> logLoginFailure(String message) async {
    debugPrint('[Auth] Login failure: $message');
    await _analytics?.logEvent(
      name: 'auth_login_failure',
      parameters: {'message': message},
    );
    await _crashlytics?.log('Auth login failure: $message');
  }

  Future<void> logOtpFailure(String reason) async {
    debugPrint('[Auth] OTP failure: $reason');
    await _analytics?.logEvent(
      name: 'auth_otp_failure',
      parameters: {'reason': reason},
    );
    await _crashlytics?.log('Auth OTP failure: $reason');
  }

  Future<void> logLinkingResult({required bool success, String? reason}) async {
    if (success) {
      debugPrint('[Auth] Linking success');
      await _analytics?.logEvent(name: 'auth_link_success');
      return;
    }

    final message = reason ?? 'unknown';
    debugPrint('[Auth] Linking failure: $message');
    await _analytics?.logEvent(
      name: 'auth_link_failure',
      parameters: {'reason': message},
    );
    await _crashlytics?.log('Auth linking failure: $message');
  }
}
