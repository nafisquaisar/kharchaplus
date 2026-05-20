import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final canCheck = await auth.canCheckBiometrics;
      final isSupported = await auth.isDeviceSupported();
      final available = await auth.getAvailableBiometrics();

      debugPrint("canCheck: $canCheck");
      debugPrint("isSupported: $isSupported");
      debugPrint("available: $available");

      if (!canCheck || !isSupported) {
        return false;
      }

      final authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint',
        biometricOnly: true,
      );

      debugPrint("authenticated: $authenticated");

      return authenticated;
    } catch (e) {
      debugPrint("Biometric Error: $e");
      return false;
    }
  }
}