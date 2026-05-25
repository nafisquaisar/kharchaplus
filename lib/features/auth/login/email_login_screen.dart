import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_viewmodel.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final inputFill = colorScheme.surfaceContainerHighest;
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Email Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isSignUp ? 'Create account' : 'Welcome back',
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isSignUp
                    ? 'Use email and password to create your account.'
                    : 'Sign in using your email and password.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: inputFill,
                  border: inputBorder,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: inputFill,
                  border: inputBorder,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          if (email.isEmpty || password.length < 6) {
                            _showSnack(context, 'Enter a valid email and password.');
                            return;
                          }

                          final success = _isSignUp
                              ? await vm.signUpWithEmailPassword(
                                  email: email,
                                  password: password,
                                )
                              : await vm.signInWithEmailPassword(
                                  email: email,
                                  password: password,
                                );

                          if (!context.mounted) {
                            return;
                          }

                          if (!success) {
                            _showSnack(context,
                                vm.errorMessage ?? 'Email login failed');
                          } else {
                            Navigator.pop(context);
                          }
                        },
                  child: vm.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isSignUp ? 'Create Account' : 'Sign In'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: vm.isLoading
                    ? null
                    : () {
                        setState(() {
                          _isSignUp = !_isSignUp;
                        });
                      },
                child: Text(
                  _isSignUp
                      ? 'Already have an account? Sign in'
                      : 'No account? Create one',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

