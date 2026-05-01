import 'package:shared_preferences/shared_preferences.dart';

class AuthCooldownStorage {
  static const _cooldownEndKey = 'auth_otp_cooldown_end_ms';
  static const _lastPhoneKey = 'auth_otp_last_phone';

  Future<void> saveCooldown({
    required int cooldownEndMs,
    required String phoneNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_cooldownEndKey, cooldownEndMs);
    await prefs.setString(_lastPhoneKey, phoneNumber);
  }

  Future<int?> getCooldownEndMs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_cooldownEndKey);
  }

  Future<String?> getLastPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastPhoneKey);
  }

  Future<void> clearCooldown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cooldownEndKey);
  }
}

