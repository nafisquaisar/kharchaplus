import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'features/auth/data/datasources/firebase_auth_data_source.dart';
import 'features/auth/data/datasources/firestore_user_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_user_profile_use_case.dart';
import 'features/auth/domain/usecases/link_email_password_use_case.dart';
import 'features/auth/domain/usecases/link_phone_use_case.dart';
import 'features/auth/domain/usecases/logout_use_case.dart';
import 'features/auth/domain/usecases/save_user_profile_use_case.dart';
import 'features/auth/domain/usecases/send_otp_use_case.dart';
import 'features/auth/domain/usecases/sign_in_with_email_password_use_case.dart';
import 'features/auth/domain/usecases/sign_in_with_google_use_case.dart';
import 'features/auth/domain/usecases/sign_up_with_email_password_use_case.dart';
import 'features/auth/domain/usecases/verify_otp_use_case.dart';
import 'features/auth/extra/AuthWrapper.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/Expense/viewmodel/expense_viewmodel.dart';
import 'features/auth/data/services/auth_logger.dart';
import 'features/auth/data/services/auth_cooldown_storage.dart';
import 'features/auth/data/services/auth_debug_diagnostics.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AuthDebugDiagnostics.logStartup();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );


  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthLogger(
            analytics: FirebaseAnalytics.instance,
            crashlytics: FirebaseCrashlytics.instance,
          ),
        ),
        Provider(create: (_) => AuthCooldownStorage()),
        Provider(create: (_) => FirebaseAuthDataSource()),
        Provider(create: (_) => FirestoreUserDataSource()),
        ProxyProvider3<FirebaseAuthDataSource, FirestoreUserDataSource,
            AuthLogger, AuthRepository>(
          update: (_, authSource, userSource, logger, __) =>
              AuthRepositoryImpl(authSource, userSource, logger),
        ),
        Provider(
          create: (context) =>
              SignInWithGoogleUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) =>
              SignInWithEmailPasswordUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) =>
              SignUpWithEmailPasswordUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) => SendOtpUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) => VerifyOtpUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) => LinkPhoneUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) =>
              LinkEmailPasswordUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) => LogoutUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) =>
              GetUserProfileUseCase(context.read<AuthRepository>()),
        ),
        Provider(
          create: (context) =>
              SaveUserProfileUseCase(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            authRepository: context.read<AuthRepository>(),
            signInWithGoogle: context.read<SignInWithGoogleUseCase>(),
            signInWithEmailPassword:
                context.read<SignInWithEmailPasswordUseCase>(),
            signUpWithEmailPassword:
                context.read<SignUpWithEmailPasswordUseCase>(),
            sendOtp: context.read<SendOtpUseCase>(),
            verifyOtp: context.read<VerifyOtpUseCase>(),
            linkPhone: context.read<LinkPhoneUseCase>(),
            linkEmailPassword: context.read<LinkEmailPasswordUseCase>(),
            logout: context.read<LogoutUseCase>(),
            getUserProfile: context.read<GetUserProfileUseCase>(),
            saveUserProfile: context.read<SaveUserProfileUseCase>(),
            logger: context.read<AuthLogger>(),
            cooldownStorage: context.read<AuthCooldownStorage>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ExpenseViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF4F46E5),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}