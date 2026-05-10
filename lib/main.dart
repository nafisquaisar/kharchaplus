import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/features/Expense/data/repository/ExpenseCardRepository.dart';
import 'package:expense_tracker/features/Expense/data/repository/category_repository.dart';
import 'package:expense_tracker/features/Expense/presentation/viewmodel/CategoryViewModel.dart';
import 'package:expense_tracker/features/Expense/presentation/viewmodel/ExpenseCardViewModel.dart';
import 'package:expense_tracker/features/Profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'core/constants/AppColors.dart';
import 'core/utils/system_ui.dart';
import 'features/Expense/data/repository/expense_repository.dart';
import 'features/Expense/presentation/viewmodel/ExpenseFilterViewModel.dart';
import 'features/Expense/presentation/viewmodel/expense_viewmodel.dart';
import 'features/Profile/data/datasource/profile_remote_data_source.dart';
import 'features/Profile/data/repository/profile_repository.dart';
import 'features/Profile/data/repository/profile_repository_impl.dart';
import 'features/Track/FoodTracking/domain/repository/food_repository_impl.dart';
import 'features/Track/FoodTracking/presentation/viewmodel/food_cycle_viewmodel.dart';
import 'features/Track/FoodTracking/services/FirebaseFoodService.dart';
import 'features/auth/data/datasources/firebase_auth_data_source.dart';
import 'features/auth/data/datasources/firestore_user_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_user_profile_use_case.dart';
import 'features/auth/domain/usecases/link_email_password_use_case.dart';
import 'features/auth/domain/usecases/link_phone_use_case.dart';
import 'features/auth/domain/usecases/logout_use_case.dart';
import 'features/auth/domain/usecases/send_otp_use_case.dart';
import 'features/auth/domain/usecases/sign_in_with_email_password_use_case.dart';
import 'features/auth/domain/usecases/sign_in_with_google_use_case.dart';
import 'features/auth/domain/usecases/sign_up_with_email_password_use_case.dart';
import 'features/auth/domain/usecases/verify_otp_use_case.dart';
import 'features/auth/extra/AuthWrapper.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
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

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 👈 same as your theme
      statusBarIconBrightness: Brightness.light, // white icons
      statusBarBrightness: Brightness.dark, // iOS support
    ),
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
            logger: context.read<AuthLogger>(),
            cooldownStorage: context.read<AuthCooldownStorage>(),
          ),
        ),
        Provider<ProfileRemoteDataSource>(
          create: (_) => ProfileRemoteDataSource(),
        ),
        Provider<ProfileRepository>(
          create: (context) => ProfileRepositoryImpl(
            context.read<ProfileRemoteDataSource>(),
          ),
        ),
        ChangeNotifierProxyProvider<AuthViewModel, ProfileViewModel>(
          create: (context) => ProfileViewModel(
            context.read<ProfileRepository>(),
          ),
          update: (_, authVm, profileVm) =>
              profileVm!..bindUser(authVm.currentUser?.uid),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseViewModel(ExpenseRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseCardViewModel(ExpenseCardRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryViewModel(CategoryRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseFilterViewModel(),
        ),

        ChangeNotifierProvider(
          create: (_) => FoodCycleViewModel(
            FoodRepositoryImpl(
              firebaseService:  FirebaseFoodService(
                firestore: FirebaseFirestore.instance,
                auth: FirebaseAuth.instance,
              ),
            ),
          )..loadCycles(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kharcha Plus',

        builder: (context, child) {
          // 🔥 GLOBAL CONTROL
          SystemUI.setLight();

          return child!;
        },

        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: AppColors.primary,
        ),

        home: const AuthWrapper(),
      )
    );
  }
}