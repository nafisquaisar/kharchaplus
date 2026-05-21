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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart' as provider;
import 'package:timezone/data/latest.dart' as tz;

import 'core/constants/AppColors.dart';
import 'core/services/isar_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/utils/system_ui.dart';
import 'features/Expense/data/repository/expense_repository.dart';
import 'features/Expense/presentation/viewmodel/ExpenseFilterViewModel.dart';
import 'features/Expense/presentation/viewmodel/expense_viewmodel.dart';
import 'features/Profile/data/datasource/profile_remote_data_source.dart';
import 'features/Profile/data/repository/profile_repository.dart';
import 'features/Profile/data/repository/profile_repository_impl.dart';
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
import 'core/services/recent_activity_service.dart';
import 'features/Home/data/datasource/local/RecentActivityLocalDataSource.dart';
import 'features/Home/data/datasource/remote/recent_activity_remote_datasource.dart';
import 'features/Home/data/repository/recent_activity_repository_impl.dart';
import 'features/Home/domain/repository/RecentActivityRepository.dart';
import 'features/Profile/data/repository/profile_stats_repository.dart';
import 'features/Profile/data/repository/profile_stats_repository_impl.dart';
import 'features/Profile/data/datasource/profile_stats_local_data_source.dart';
import 'features/Profile/data/datasource/profile_stats_remote_data_source.dart';
import 'features/Profile/presentation/viewmodel/profile_streak_viewmodel.dart';
import 'features/Profile/presentation/widgets/profile_streak_lifecycle_handler.dart';
import 'features/Profile/data/datasource/profile_achievement_local_data_source.dart';
import 'features/Profile/data/datasource/profile_achievement_remote_data_source.dart';
import 'features/Profile/data/repository/profile_achievement_repository.dart';
import 'features/Profile/data/repository/profile_achievement_repository_impl.dart';
import 'features/Achievements/presentation/viewmodel/profile_achievement_viewmodel.dart';
import 'features/Profile/data/datasource/overview_remote_data_source.dart';
import 'features/Profile/data/datasource/overview_local_data_source.dart';
import 'features/Profile/data/repository/overview_repository.dart';
import 'features/Profile/data/repository/overview_repository_impl.dart';
import 'features/Profile/presentation/viewmodel/overview_viewmodel.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:
    DefaultFirebaseOptions.currentPlatform,
  );

  /// KEEP THIS HERE
  await IsarService.init();

  runApp(
    const ProviderScope(
      child: ExpenseTrackerApp(),
    ),
  );

  /// background tasks
  Future.microtask(() async {

    tz.initializeTimeZones();

    await FirebaseAppCheck.instance.activate(
      androidProvider:
      AndroidProvider.debug,
    );

    await AuthDebugDiagnostics.logStartup();

    FirebaseFirestore.instance.settings =
    const Settings(
      persistenceEnabled: true,
    );

    SystemChrome.setSystemUIOverlayStyle(

      const SystemUiOverlayStyle(
        statusBarColor:
        Colors.transparent,

        statusBarIconBrightness:
        Brightness.light,

        statusBarBrightness:
        Brightness.dark,
      ),
    );
  });
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return provider.MultiProvider(
      providers: [
        // =========================
        // AUTH LOGGER
        // =========================

        provider.Provider(
          create: (_) => AuthLogger(
            analytics: FirebaseAnalytics.instance,
            crashlytics: FirebaseCrashlytics.instance,
          ),
        ),

        provider.Provider(
          create: (_) => AuthCooldownStorage(),
        ),

        provider.Provider(
          create: (_) => FirebaseAuthDataSource(),
        ),

        provider.Provider(
          create: (_) => FirestoreUserDataSource(),
        ),

        // =========================
        // AUTH REPOSITORY
        // =========================

        provider.ProxyProvider3<FirebaseAuthDataSource, FirestoreUserDataSource,
            AuthLogger, AuthRepository>(
          update: (
            _,
            authSource,
            userSource,
            logger,
            __,
          ) {
            return AuthRepositoryImpl(
              authSource,
              userSource,
              logger,
            );
          },
        ),

        // =========================
        // AUTH USECASES
        // =========================

        provider.Provider(
          create: (context) => SignInWithGoogleUseCase(
            context.read<AuthRepository>(),
          ),
        ),

        provider.Provider(
          create: (context) => SignInWithEmailPasswordUseCase(
            context.read<AuthRepository>(),
          ),
        ),

        provider.Provider(
          create: (context) => SignUpWithEmailPasswordUseCase(
            context.read<AuthRepository>(),
          ),
        ),

        provider.Provider(
          create: (context) => SendOtpUseCase(
            context.read<AuthRepository>(),
          ),
        ),

        provider.Provider(
          create: (context) => VerifyOtpUseCase(
            context.read<AuthRepository>(),
          ),
        ),

        provider.Provider(
          create: (context) => LinkPhoneUseCase(
            context.read<AuthRepository>(),
          ),
        ),

        provider.Provider(
          create: (context) => LinkEmailPasswordUseCase(
            context.read<AuthRepository>(),
          ),
        ),

        provider.Provider(
          create: (context) => LogoutUseCase(
            context.read<AuthRepository>(),
          ),
        ),

        provider.Provider(
          create: (context) => GetUserProfileUseCase(
            context.read<AuthRepository>(),
          ),
        ),

        // =========================
        // AUTH VIEWMODEL
        // =========================

        provider.ChangeNotifierProvider(
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

        // =========================
        // PROFILE
        // =========================

        provider.Provider<ProfileRemoteDataSource>(
          create: (_) => ProfileRemoteDataSource(),
        ),

        provider.Provider<ProfileRepository>(
          create: (context) => ProfileRepositoryImpl(
            context.read<ProfileRemoteDataSource>(),
          ),
        ),

        provider.ChangeNotifierProxyProvider<AuthViewModel, ProfileViewModel>(
          create: (context) => ProfileViewModel(
            context.read<ProfileRepository>(),
          ),
          update: (
            _,
            authVm,
            profileVm,
          ) {
            return profileVm!
              ..bindUser(
                authVm.currentUser?.uid,
              );
          },
        ),

        provider.Provider<ProfileStatsLocalDataSource>(
          create: (_) => ProfileStatsLocalDataSourceImpl(IsarService.isar),
        ),

        provider.Provider<ProfileStatsRemoteDataSource>(
          create: (_) => ProfileStatsRemoteDataSource(),
        ),

        provider.Provider<ProfileStatsRepository>(
          create: (context) => ProfileStatsRepositoryImpl(
            context.read<ProfileStatsLocalDataSource>(),
            context.read<ProfileStatsRemoteDataSource>(),
            IsarService.isar,
          ),
        ),

        provider.ChangeNotifierProxyProvider<AuthViewModel, ProfileStreakViewModel>(
          create: (context) => ProfileStreakViewModel(
            context.read<ProfileStatsRepository>(),
          ),
          update: (
            _,
            authVm,
            streakVm,
          ) {
            return streakVm!
              ..bindUser(
                authVm.currentUser?.uid,
              );
          },
        ),

        provider.Provider<ProfileAchievementLocalDataSource>(
          create: (_) => ProfileAchievementLocalDataSourceImpl(IsarService.isar),
        ),

        provider.Provider<ProfileAchievementRemoteDataSource>(
          create: (_) => ProfileAchievementRemoteDataSource(),
        ),

        provider.Provider<ProfileAchievementRepository>(
          create: (context) => ProfileAchievementRepositoryImpl(
            context.read<ProfileAchievementLocalDataSource>(),
            context.read<ProfileAchievementRemoteDataSource>(),
            context.read<ProfileStatsLocalDataSource>(),
            IsarService.isar,
          ),
        ),

        provider.ChangeNotifierProxyProvider<AuthViewModel, ProfileAchievementViewModel>(
          create: (context) => ProfileAchievementViewModel(
            context.read<ProfileAchievementRepository>(),
          ),
          update: (
            _,
            authVm,
            achievementVm,
          ) {
            return achievementVm!
              ..bindUser(
                authVm.currentUser?.uid,
              );
          },
        ),

        // =========================
        // RECENT ACTIVITY
        // =========================

        provider.Provider<RecentActivityRepository>(
          create: (_) => RecentActivityRepositoryImpl(
            RecentActivityLocalDataSourceImpl(IsarService.isar),
            RecentActivityRemoteDataSourceImpl(
              firestore: FirebaseFirestore.instance,
              auth: FirebaseAuth.instance,
            ),
          ),
        ),

        provider.Provider<RecentActivityService>(
          create: (context) => RecentActivityService(
            context.read<RecentActivityRepository>(),
          ),
        ),

        // =========================
        // EXPENSE
        // =========================

        provider.ChangeNotifierProvider(
          create: (context) => ExpenseViewModel(
            ExpenseRepository(),
            context.read<RecentActivityService>(),
          ),
        ),

        provider.ChangeNotifierProvider(
          create: (context) => ExpenseCardViewModel(
            ExpenseCardRepository(),
            context.read<RecentActivityService>(),
          ),
        ),

        provider.ChangeNotifierProvider(
          create: (_) => CategoryViewModel(
            CategoryRepository(),
          ),
        ),

        provider.ChangeNotifierProvider(
          create: (_) => ExpenseFilterViewModel(),
        ),

        // =========================
        // OVERVIEW / DASHBOARD
        // =========================

        provider.Provider<OverviewRemoteDataSource>(
          create: (_) => OverviewRemoteDataSource(),
        ),

        provider.Provider<OverviewLocalDataSource>(
          create: (_) => OverviewLocalDataSourceImpl(IsarService.isar),
        ),

        provider.Provider<OverviewRepository>(
          create: (context) => OverviewRepositoryImpl(
            context.read<OverviewLocalDataSource>(),
            context.read<OverviewRemoteDataSource>(),
          ),
        ),

        provider.ChangeNotifierProxyProvider<AuthViewModel, OverviewViewModel>(
          create: (context) => OverviewViewModel(
            context.read<OverviewRepository>(),
          ),
          update: (
            _,
            authVm,
            overviewVm,
          ) {
            return overviewVm!
              ..bindUser(
                authVm.currentUser?.uid,
              );
          },
        ),
      ],
      child:ValueListenableBuilder<bool>(
      valueListenable: ThemeController.isDark,
      builder: (context, isDark, child) {
        AppColors.isDark = isDark;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Kharcha Plus',

          builder: (context, child) {
            SystemUI.setLight();
            return child!;
          },

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          themeMode:
          isDark ? ThemeMode.dark : ThemeMode.light,

          home: const ProfileStreakLifecycleHandler(
            child: AuthWrapper(),
          ),
        );
      },
    ),
    );
  }
}
