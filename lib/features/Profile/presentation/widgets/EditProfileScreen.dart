import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();

    final vm = context.read<AuthViewModel>();
    final user = vm.currentUser;

    _nameController = TextEditingController(text: user?.displayName ?? "");
    _emailController = TextEditingController(text: user?.email ?? "");
    _phoneController = TextEditingController(text: user?.phoneNumber ?? "");

    _photoUrl = user?.photoUrl;
  }

  /// 📸 Pick Image
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  /// ☁️ Upload Image to Firebase
  Future<String?> _uploadImage(String uid) async {
    if (_imageFile == null) return _photoUrl;

    final ref = FirebaseStorage.instance
        .ref()
        .child("profile_images/$uid.jpg");

    await ref.putFile(_imageFile!);

    return await ref.getDownloadURL();
  }

  /// 💾 Save Profile
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<AuthViewModel>();
    final user = vm.currentUser;

    if (user == null) return;

    /// 🔥 Upload image (if selected)
    final uploadedUrl = await _uploadImage(user.uid);

    /// 🔥 FINAL SAVE (IMPORTANT FIX)
    final success = await vm.saveProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      photoUrl: uploadedUrl ?? _photoUrl, // ✅ FIXED
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? "Update failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

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
                          ? Image.network(
                        _photoUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                          : Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.textSecondary,
                      )),
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

              ElevatedButton(
                onPressed: vm.isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: vm.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save"),
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
}