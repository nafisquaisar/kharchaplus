import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_tracker/features/auth/data/services/auth_cooldown_storage.dart';

void main() {
  test('cooldown storage saves and restores values', () async {
    SharedPreferences.setMockInitialValues({});

    final storage = AuthCooldownStorage();
    await storage.saveCooldown(
      cooldownEndMs: 123456,
      phoneNumber: '+15550001111',
    );

    final endMs = await storage.getCooldownEndMs();
    final phone = await storage.getLastPhoneNumber();

    expect(endMs, 123456);
    expect(phone, '+15550001111');
  });
}

