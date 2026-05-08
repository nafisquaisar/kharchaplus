import 'dart:async';
import 'dart:io';

import 'package:expense_tracker/features/auth/domain/entities/user_profile.dart';
import 'package:expense_tracker/features/Profile/data/repository/profile_repository.dart';

import '../datasource/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Stream<UserProfile?> watchProfile(String uid) {
    return _dataSource.watchProfile(uid);
  }

  @override
  Future<String> uploadProfileImage({
    required String uid,
    required File file,
    String? oldPhotoUrl,
    void Function(double progress)? onProgress,
  }) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _dataSource.profileImageRef(uid, fileName);

    final uploadTask = _dataSource.uploadProfileImage(ref, file);

    StreamSubscription? subscription;
    if (onProgress != null) {
      var lastProgress = 0.0;
      var lastEmit = DateTime.fromMillisecondsSinceEpoch(0);
      subscription = uploadTask.snapshotEvents.listen((snapshot) {
        final total = snapshot.totalBytes == 0 ? 1 : snapshot.totalBytes;
        final progress = snapshot.bytesTransferred / total;
        final now = DateTime.now();
        if ((progress - lastProgress).abs() >= 0.02 ||
            now.difference(lastEmit) > const Duration(milliseconds: 200) ||
            progress >= 1.0) {
          lastProgress = progress;
          lastEmit = now;
          onProgress(progress);
        }
      });
    }

    try {
      await _retry(() => uploadTask);
      final downloadUrl = await _retry(() => _dataSource.getDownloadUrl(ref));
      final cacheBusted = _appendCacheBuster(downloadUrl);

      if (oldPhotoUrl != null && oldPhotoUrl.isNotEmpty) {
        await _safeDelete(oldPhotoUrl);
      }

      return cacheBusted;
    } finally {
      await subscription?.cancel();
    }
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _retry(() => _dataSource.saveProfile(profile));

  }

  String _appendCacheBuster(String url) {
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}v=${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _safeDelete(String url) async {
    try {
      await _dataSource.deleteImageByUrl(url);
    } catch (_) {
      // Ignore delete failures for old images.
    }
  }

  Future<T> _retry<T>(Future<T> Function() task) async {
    const maxAttempts = 3;
    var delayMs = 300;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await task();
      } catch (_) {
        if (attempt == maxAttempts) {
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: delayMs));
        delayMs *= 2;
      }
    }
    throw StateError('Unreachable');
  }
}