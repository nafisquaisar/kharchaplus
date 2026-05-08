import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../auth/viewmodel/auth_viewmodel.dart';
import '../../../../core/constants/KharchaThemeColors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  File? _imageFile;
  String? _photoUrl;
  bool _isUploadingImage = false;
  double _uploadProgress = 0.0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    final vm = context.read<AuthViewModel>();

    _nameController = TextEditingController(text: vm.resolvedName);
    _emailController = TextEditingController(text: vm.resolvedEmail);
    _phoneController = TextEditingController(text: vm.resolvedPhone);

    _photoUrl = vm.resolvedPhotoUrl;
  }

  /// 📸 Pick Image
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
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

  String _appendCacheBuster(String url) {
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}v=${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<T> _retry<T>(Future<T> Function() task) async {
    const maxAttempts = 2;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await task();
      } catch (_) {
        if (attempt == maxAttempts) {
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: 400 * attempt));
      }
    }
    throw StateError('Unreachable');
  }

  /// ☁️ Upload Image to Firebase
  Future<String?> _uploadImage(String uid) async {
    if (_imageFile == null) return _photoUrl;

    final compressed = await _compressImage(_imageFile!);
    final uploadFile = compressed ?? _imageFile!;

    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_images/$uid.jpg');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      cacheControl: 'public,max-age=3600',
    );

    setState(() {
      _isUploadingImage = true;
      _uploadProgress = 0.0;
    });

    final uploadTask = ref.putFile(uploadFile, metadata);
    final progressSubscription = uploadTask.snapshotEvents.listen((snapshot) {
      if (!mounted) return;
      final total = snapshot.totalBytes == 0 ? 1 : snapshot.totalBytes;
      setState(() {
        _uploadProgress = snapshot.bytesTransferred / total;
      });
    });

    try {
      await _retry(() => uploadTask);
      final downloadUrl = await _retry(ref.getDownloadURL);
      return _appendCacheBuster(downloadUrl);
    } finally {
      await progressSubscription.cancel();
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  /// 💾 Save Profile
  Future<void> _save() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<AuthViewModel>();
    final user = vm.currentUser;

    if (user == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      /// 🔥 Upload image (if selected)
      final uploadedUrl = await _uploadImage(user.uid);

      /// 🔥 FINAL SAVE
      final success = await vm.saveProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        photoUrl: uploadedUrl ?? _photoUrl,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.errorMessage ?? "Update failed")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// 🔥 PROFILE IMAGE
              ///
              ///
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.card,
                    child: ClipOval(
                      child: _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : (_photoUrl != null && _photoUrl!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: _photoUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => _avatarFallback(
                                    size: 40,
                                    isLoading: true,
                                  ),
                                  errorWidget: (_, __, ___) => _avatarFallback(
                                    size: 40,
                                    isLoading: false,
                                  ),
                                )
                              : _avatarFallback(size: 40, isLoading: false)),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.kharchaGradient,
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _buildField(_nameController, "Name"),
              const SizedBox(height: 12),
              _buildField(_emailController, "Email"),
              const SizedBox(height: 12),
              _buildField(_phoneController, "Phone"),

              const SizedBox(height: 25),

              Selector<AuthViewModel, bool>(
                selector: (_, vm) => vm.isSavingProfile,
                builder: (context, isSavingProfile, _) {
                  final isBusy = isSavingProfile || _isSubmitting || _isUploadingImage;
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: isBusy ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: isBusy
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Save"),
                      ),
                      if (_isUploadingImage)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            children: [
                              LinearProgressIndicator(value: _uploadProgress),
                              const SizedBox(height: 6),
                              Text(
                                "Uploading image...",
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController c, String label) {
    return TextFormField(
      controller: c,
      validator: (v) =>
      v == null || v.isEmpty ? "Enter $label" : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _avatarFallback({required double size, required bool isLoading}) {
    if (isLoading) {
      return SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return Icon(
      Icons.person,
      size: size,
      color: AppColors.textSecondary,
    );
  }
}