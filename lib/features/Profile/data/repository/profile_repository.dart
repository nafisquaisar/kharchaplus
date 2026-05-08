import 'dart:io';

import 'package:expense_tracker/features/auth/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Stream<UserProfile?> watchProfile(String uid);

  Future<String> uploadProfileImage({
    required String uid,
    required File file,
    String? oldPhotoUrl,
    void Function(double progress)? onProgress,
  });

  Future<void> saveProfile(UserProfile profile);
}
