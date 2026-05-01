import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late final TextEditingController _phoneController;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName ?? '');
    _emailController = TextEditingController(text: widget.user.email ?? '');
    _phoneController = TextEditingController(text: widget.user.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final missing = widget.missingFields;
    final isPhoneUser = widget.user.providers.contains('phone');
    final isEmailUser = widget.user.providers.contains('email');

    final needsEmailLink = missing.contains(ProfileField.email) && isPhoneUser;
    final needsPhoneLink = missing.contains(ProfileField.phone) && isEmailUser;

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
              if (needsEmailLink) ...[
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Create a password',
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: vm.isLoading
                        ? null
                        : () async {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();

                            if (email.isEmpty || password.length < 6) {
                              _showSnack(context,
                                  'Enter a valid email and password (min 6).');
                              return;
                            }

                            final success = await vm.linkEmailPassword(
                              email: email,
                              password: password,
                            );

                            if (!context.mounted) {
                              return;
                            }

                            if (!success) {
                              _showSnack(context,
                                  vm.errorMessage ?? 'Email linking failed');
                            }
                          },
                    child: const Text('Link Email'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (missing.contains(ProfileField.phone)) ...[
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  hint: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
              ],
              if (needsPhoneLink) ...[
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: vm.isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PhoneScreen(isLinking: true),
                              ),
                            );
                          },
                    child: const Text('Link Phone'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          final name = _nameController.text.trim();
                          final email = _emailController.text.trim();
                          final phone = _phoneController.text.trim();

                          if (missing.contains(ProfileField.name) && name.isEmpty) {
                            _showSnack(context, 'Name is required');
                            return;
                          }
                          if (missing.contains(ProfileField.email) && email.isEmpty) {
                            _showSnack(context, 'Email is required');
                            return;
                          }
                          if (missing.contains(ProfileField.phone) && phone.isEmpty) {
                            _showSnack(context, 'Phone is required');
                            return;
                          }

                          if (needsEmailLink && _passwordController.text.trim().isEmpty) {
                            _showSnack(context, 'Link email before saving');
                            return;
                          }

                          final success = await vm.saveProfile(
                            name: name,
                            email: email,
                            phone: phone,
                          );

                          if (!context.mounted) {
                            return;
                          }

                          if (!success) {
                            _showSnack(context,
                                vm.errorMessage ?? 'Profile update failed');
                          }
                        },
                  child: vm.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Continue'),
                ),
              ),
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

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

