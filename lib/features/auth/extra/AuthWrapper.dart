import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../MainScreen.dart';
import '../login/LoginScreen.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../domain/entities/auth_state.dart';
import '../profile/profile_completion_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, vm, _) {
        final state = vm.state;

        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          return const MainScreen();
        }

        // if (state is AuthProfileIncomplete) {
        //   return ProfileCompletionScreen(user: state.user, missingFields: state.missingFields);
        // }

        return const LoginScreen();
      },
    );
  }
}