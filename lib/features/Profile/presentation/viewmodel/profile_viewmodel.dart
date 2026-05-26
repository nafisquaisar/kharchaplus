import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:expense_tracker/features/auth/domain/entities/auth_state.dart';
import 'package:expense_tracker/features/auth/domain/entities/auth_user.dart';
import 'package:expense_tracker/features/Profile/data/repository/profile_repository.dart';

import '../../../auth/domain/entities/user_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository;

  StreamSubscription<UserProfile?>? _profileSubscription;
  String? _userId;
  UserProfile? _profile;
  File? _selectedImageFile;
  bool _isUploadingImage = false;
  bool _isSavingProfile = false;
  double _uploadProgress = 0.0;
  String? _errorMessage;

  ProfileViewModel(this._repository);

  UserProfile? get profile => _profile;
  File? get selectedImageFile => _selectedImageFile;
  bool get isUploadingImage => _isUploadingImage;
  bool get isSavingProfile => _isSavingProfile;
  double get uploadProgress => _uploadProgress;
  String? get errorMessage => _errorMessage;

  String get resolvedName => _profile?.name ?? '';
  String get resolvedEmail => _profile?.email ?? '';
  String get resolvedPhone => _profile?.phone ?? '';
  String? get resolvedPhotoUrl => _profile?.photoUrl;

  Set<ProfileField> missingProfileFields(AuthUser user) {
    final missing = <ProfileField>{};

    final name = _profile?.name ?? user.displayName ?? '';
    if (name.trim().isEmpty) {
      missing.add(ProfileField.name);
    }

    final email = _profile?.email ?? user.email ?? '';
    if (email.trim().isEmpty) {
      missing.add(ProfileField.email);
    }

    // final phone = _profile?.phone ?? user.phoneNumber ?? '';
    // if (phone.trim().isEmpty) {
    //   missing.add(ProfileField.phone);
    // }

    return missing;
  }

  void bindUser(String? uid) {
    if (_userId == uid) {
      return;
    }

    _userId = uid;
    _profileSubscription?.cancel();
    _profileSubscription = null;

    _profile = null;
    _selectedImageFile = null;
    _isUploadingImage = false;
    _isSavingProfile = false;
    _uploadProgress = 0.0;
    _errorMessage = null;
    notifyListeners();

    if (uid == null || uid.isEmpty) {
      return;
    }

    _profileSubscription = _repository
        .watchProfile(uid)
        .listen(
          (profile) {
            if (!_isSameProfile(_profile, profile)) {
              _profile = profile;
              notifyListeners();
            }
          },
          onError: (error) {
            _errorMessage = error.toString();
            notifyListeners();
          },
        );
  }

  void setSelectedImageFile(File? file) {
    if (file?.path == _selectedImageFile?.path) {
      return;
    }
    _selectedImageFile = file;
    notifyListeners();
  }

  Future<bool> saveProfile({required String name, required String email, required String phone, String? photoUrl,}) async {
    if (_userId == null || _userId!.isEmpty) {
      _errorMessage = 'Missing authenticated user.';
      notifyListeners();
      return false;
    }

    if (_isSavingProfile) {
      return false;
    }

    _isSavingProfile = true;
    _errorMessage = null;
    notifyListeners();

    final previousPhotoUrl = _profile?.photoUrl ?? photoUrl;

    try {
      String? updatedPhotoUrl = previousPhotoUrl;
      if (_selectedImageFile != null) {
        _setUploadingImage(true, 0.0);
        final compressed = await _compressImage(_selectedImageFile!);
        final file = compressed ?? _selectedImageFile!;

        updatedPhotoUrl = await _repository.uploadProfileImage(
          uid: _userId!,
          file: file,
          oldPhotoUrl: previousPhotoUrl,
          onProgress: _setUploadProgress,
        );
      }

      final profile = UserProfile(
        uid: _userId!,
        name: name,
        email: email,
        phone: phone,
        photoUrl: updatedPhotoUrl,
      );

      await _repository.saveProfile(profile);

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updateDisplayName(name);

        if (updatedPhotoUrl != null && updatedPhotoUrl.isNotEmpty) {
          await user.updatePhotoURL(updatedPhotoUrl);
        }

        await user.reload();
      }

      _selectedImageFile = null;

      if (previousPhotoUrl != null && previousPhotoUrl.isNotEmpty) {
        await CachedNetworkImage.evictFromCache(previousPhotoUrl);
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setUploadingImage(false, _uploadProgress);
      _isSavingProfile = false;
      notifyListeners();
    }
  }

  void _setUploadingImage(bool value, double progress) {
    _isUploadingImage = value;
    _uploadProgress = progress;
    notifyListeners();
  }

  void _setUploadProgress(double progress) {
    if ((progress - _uploadProgress).abs() < 0.01 && progress < 1.0) {
      return;
    }
    _uploadProgress = progress;
    notifyListeners();
  }

  Future<File?> _compressImage(File file) async {
    final targetPath =
        '${Directory.systemTemp.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressed = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
      minWidth: 512,
      minHeight: 512,
      format: CompressFormat.jpeg,
    );

    return compressed != null ? File(compressed.path) : file;
  }

  bool _isSameProfile(UserProfile? current, UserProfile? next) {
    if (current == null && next == null) {
      return true;
    }
    if (current == null || next == null) {
      return false;
    }
    return current.uid == next.uid &&
        current.name == next.name &&
        current.email == next.email &&
        current.phone == next.phone &&
        current.photoUrl == next.photoUrl;
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }
}
