import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../viewmodel/profile_viewmodel.dart';
import '../../../../core/constants/AppColors.dart';
import 'package:expense_tracker/features/auth/domain/entities/user_profile.dart';

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
  bool _didPrefill = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
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
      context.read<ProfileViewModel>().setSelectedImageFile(File(picked.path));
    }
  }

  /// 💾 Save Profile
  Future<void> _save(ProfileViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await vm.saveProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      photoUrl: vm.resolvedPhotoUrl,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else if (vm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppColors.accent,
        foregroundColor: colorScheme.onPrimary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Selector<ProfileViewModel, _EditProfileUiState>(
            selector: (_, vm) => _EditProfileUiState(
              vm.profile,
              vm.selectedImageFile,
              vm.isUploadingImage,
              vm.isSavingProfile,
              vm.uploadProgress,
            ),
            builder: (context, state, _) {
              final profile = state.profile;
              if (!_didPrefill && profile != null) {
                _nameController.text = profile.name ?? '';
                _emailController.text = profile.email ?? '';
                _phoneController.text = profile.phone ?? '';
                _didPrefill = true;
              }

              final photoUrl = profile?.photoUrl;
              final isBusy = state.isUploadingImage || state.isSavingProfile;

              return Column(
                children: [
                  /// 🔥 PROFILE IMAGE
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: colorScheme.surfaceVariant,
                        child: ClipOval(
                          child: state.selectedImageFile != null
                              ? Image.file(
                                  state.selectedImageFile!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : (photoUrl != null && photoUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: photoUrl,
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
                          onTap: isBusy ? null : _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.kharchaGradient,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: colorScheme.onPrimary,
                            ),
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

                  ElevatedButton(
                    onPressed: isBusy
                        ? null
                        : () => _save(context.read<ProfileViewModel>()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: isBusy
                        ? CircularProgressIndicator(color: colorScheme.onPrimary)
                        : const Text("Save"),
                  ),
                  if (state.isUploadingImage)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: [
                          LinearProgressIndicator(value: state.uploadProgress),
                          const SizedBox(height: 6),
                          Text(
                            "Uploading image...",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${(state.uploadProgress * 100).toStringAsFixed(0)}%",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
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
        fillColor: Theme.of(context).colorScheme.surface,
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

class _EditProfileUiState {
  final UserProfile? profile;
  final File? selectedImageFile;
  final bool isUploadingImage;
  final bool isSavingProfile;
  final double uploadProgress;

  const _EditProfileUiState(
    this.profile,
    this.selectedImageFile,
    this.isUploadingImage,
    this.isSavingProfile,
    this.uploadProgress,
  );

  @override
  bool operator ==(Object other) {
    return other is _EditProfileUiState &&
        other.profile == profile &&
        other.selectedImageFile?.path == selectedImageFile?.path &&
        other.isUploadingImage == isUploadingImage &&
        other.isSavingProfile == isSavingProfile &&
        other.uploadProgress == uploadProgress;
  }

  @override
  int get hashCode => Object.hash(
        profile,
        selectedImageFile?.path,
        isUploadingImage,
        isSavingProfile,
        uploadProgress,
      );
}
