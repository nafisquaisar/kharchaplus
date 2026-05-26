import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expense_tracker/features/Profile/presentation/viewmodel/profile_viewmodel.dart';
import '../../../core/utils/AppFlushbar.dart';
import '../domain/entities/auth_state.dart';
import '../domain/entities/auth_user.dart';
import '../phone/phone_screen.dart';
import '../viewmodel/auth_viewmodel.dart';

class ProfileCompletionScreen extends StatefulWidget {
  final AuthUser user;
  final Set<ProfileField> missingFields;

  const ProfileCompletionScreen({
    super.key,
    required this.user,
    required this.missingFields,
  });

  @override
  State<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName ?? '');
    _emailController = TextEditingController(text: widget.user.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final profileVm = context.read<ProfileViewModel>();
    final missing = widget.missingFields;
    final isPhoneUser = widget.user.providers.contains('phone');

    final needsPhoneLink = missing.contains(ProfileField.phone) && !isPhoneUser;
    final needsProfileDetails = missing.contains(ProfileField.name) ||
        missing.contains(ProfileField.email);

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Finish setting up your account',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'We need a few details before continuing.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              if (missing.contains(ProfileField.name)) ...[
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your name',
                ),
                const SizedBox(height: 16),
              ],
              if (missing.contains(ProfileField.email)) ...[
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
              ],
              // if (needsPhoneLink) ...[
              //   SizedBox(
              //     width: double.infinity,
              //     height: 48,
              //     child: OutlinedButton(
              //       onPressed: vm.isLoading
              //           ? null
              //           : () {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (_) => const PhoneScreen(isLinking: true),
              //                 ),
              //               );
              //             },
              //       child: const Text('Link Phone'),
              //     ),
              //   ),
              //   const SizedBox(height: 24),
              // ],
              if (needsProfileDetails) ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Selector<ProfileViewModel, bool>(
                    selector: (_, pvm) => pvm.isSavingProfile,
                    builder: (context, isSavingProfile, _) {
                      return ElevatedButton(
                        onPressed: isSavingProfile
                            ? null
                            : () async {
                                final name = missing.contains(ProfileField.name)
                                    ? _nameController.text.trim()
                                    : (profileVm.profile?.name ??
                                        widget.user.displayName ??
                                        '');
                                final email = missing.contains(ProfileField.email)
                                    ? _emailController.text.trim()
                                    : (profileVm.profile?.email ??
                                        widget.user.email ??
                                        '');
                                final phone = widget.user.phoneNumber ??
                                    profileVm.profile?.phone ??
                                    '';

                                if (missing.contains(ProfileField.name) && name.isEmpty) {
                                  _showSnack(context, 'Name is required');
                                  return;
                                }
                                if (missing.contains(ProfileField.email) && email.isEmpty) {
                                  _showSnack(context, 'Email is required');
                                  return;
                                }

                                final success = await profileVm.saveProfile(
                                  name: name,
                                  email: email,
                                  phone: phone,
                                  photoUrl: vm.currentUser?.photoUrl,
                                );

                                if (!context.mounted) {
                                  return;
                                }

                                if (!success) {
                                  _showSnack(context,
                                      profileVm.errorMessage ?? 'Profile update failed');
                                }
                              },
                        child: isSavingProfile
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Continue'),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _showSnack(
      BuildContext context,
      String message, {
        bool isError = false,
      }) {
    if (isError) {
      AppFlushbar.showError(context, message);
    } else {
      AppFlushbar.showSuccess(context, message);
    }
  }
}
