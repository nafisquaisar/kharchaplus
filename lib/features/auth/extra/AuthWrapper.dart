import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../MainScreen.dart';
import '../../../core/splashscreen/splash_screen.dart';
import '../../Lock/AppLockWrapper.dart';
import '../login/LoginScreen.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../domain/entities/auth_state.dart';
import '../profile/profile_completion_screen.dart';
import '../../Profile/presentation/viewmodel/profile_viewmodel.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, ProfileViewModel>(
      builder: (context, authVm, profileVm, _) {
        final state = authVm.state;

        if (state is AuthInitial || state is AuthLoading) {
          return const SplashScreen();
        }

        if (state is AuthAuthenticated) {
          final missingFields = profileVm.missingProfileFields(state.user);
          if (missingFields.isEmpty) {
            return const AppLockWrapper(
              child: MainScreen(),
            );
          }

          return ProfileCompletionScreen(
            user: state.user,
            missingFields: missingFields,
          );
        }

        return const LoginScreen();
      },
    );
  }
}