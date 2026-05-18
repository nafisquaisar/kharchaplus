# Agents guide — expense_tracker

This file is a concise, actionable guide for AI coding agents working on this Flutter project.

1) Big-picture architecture
- Flutter single-app with feature-first layout: see `lib/features/*` (auth, Home, Expense, Track, Friend, Profile). Track subfeatures live under `lib/features/Track/{FoodTracking,WaterTracking,ElectricityTracking}`.
- Shared UI and theme pieces are under `lib/core/*` (e.g. `core/Common/CommonAppBar.dart`, `core/Common/CustomBottomNav.dart`, `core/constants/AppColors.dart`).
- Primary persistence uses Firebase/Firestore: repositories under `lib/features/**/data/repository/*` (e.g. `lib/features/Expense/data/repository/expense_repository.dart`) and user profiles stored in `users/{uid}`.
- Entry point: `lib/main.dart` — Firebase is initialized, Firestore persistence is enabled, App Check is activated, `IsarService.init()` runs, and `ProviderScope` wraps the `MultiProvider` with `AuthWrapper` as the home screen.

2) Data flows and service boundaries
- UI -> ViewModel (ChangeNotifier) -> Repository -> Firestore. Example: `lib/features/Expense/presentation/viewmodel/expense_viewmodel.dart` calls `ExpenseRepository.addExpense`, which runs a Firestore transaction updating `users/{uid}/expenses`, `expense_cards`, `summary`, and `monthly_summary`.
- Food tracking flow: `MealEntryViewModel`/`FoodCycleViewModel` -> `MealRepositoryImpl` -> `FirebaseFoodService` (`lib/features/Track/FoodTracking/services/FirebaseFoodService.dart`) using Firestore + FirebaseAuth.
- Water tracking flow: Isar local storage via `core/services/isar_service.dart` with collections in `lib/features/Track/WaterTracking/data/models/*`.
- Auth flow: `lib/features/auth/viewmodel/auth_viewmodel.dart` -> `AuthRepositoryImpl` -> `FirebaseAuthDataSource` + `FirestoreUserDataSource` (profiles in `users/{uid}`); `AuthWrapper` handles profile completion via `AuthProfileIncomplete`.
- Keys: `ExpenseViewModel.userId` uses `FirebaseAuth.instance.currentUser!.uid`; Firestore collections are nested under `users/{uid}`.

3) Project-specific conventions and patterns
- Feature folder structure: many features use `data/`, `domain/`, `presentation/` (e.g. `lib/features/Expense/`, `lib/features/Profile/`, `lib/features/auth/`).
- UI pattern: ChangeNotifier + Provider with direct reads in screens (see `lib/MainScreen.dart`); `ProviderScope` wraps the app for Riverpod usage in `lib/main.dart`.
- Bottom sheets are the common create/edit UX surface (look under `*/bottomsheet/*`, e.g. `lib/features/Expense/presentation/bottomsheet/CreateExpenseCardSheet/create_expense_card_sheet.dart`).
- Styling: centralized color and formatter helpers: `lib/core/constants/AppColors.dart` and `lib/core/utils/formatters.dart`.

4) Integration points & external deps
- Dependencies in `pubspec.yaml`: firebase_core, firebase_auth, cloud_firestore, firebase_storage, firebase_messaging, firebase_app_check, firebase_analytics, firebase_crashlytics, google_sign_in, provider, flutter_riverpod, flutter_local_notifications, timezone/flutter_timezone; local storage uses Isar (`isar`, `isar_flutter_libs`) plus legacy Hive in `lib/data/*`.

5) Developer workflows (commands you must run)
- Get dependencies: `flutter pub get`
- Regenerate Hive/Isar adapters after changing the legacy Hive model in `lib/data/model/expense_model.dart` or Isar models in `lib/features/Track/WaterTracking/data/models/*`: `flutter pub run build_runner build --delete-conflicting-outputs` (typeId must be stable).
- Run app: `flutter run -d <deviceId>` or use IDE run configurations. Example for Windows: `flutter run -d windows`.
- Run analyzer/tests: `flutter analyze` and `flutter test`.
- Build release APK: `flutter build apk`; Android bundle: `flutter build appbundle`.

6) Safety notes / gotchas for agents
- Hive TypeId stability: `@HiveType(typeId: 0)` in `lib/data/model/expense_model.dart` — do NOT reuse/change existing typeIds without migration steps; this model is legacy and not wired into the main flow.
- Isar schemas: `core/services/isar_service.dart` lists WaterTracking schemas; add new models there and regenerate code before use.
- Auth guard: `ExpenseViewModel.userId` assumes `FirebaseAuth.instance.currentUser` is non-null; only call expense flows once authenticated (see `lib/features/auth/extra/AuthWrapper.dart`).
- Provider wiring: providers are configured in `lib/main.dart`; add new repositories/use cases/viewmodels to `MultiProvider` there.

7) Where to look for examples
- Persisting items: `lib/features/Expense/data/repository/expense_repository.dart` and `lib/features/Expense/presentation/viewmodel/expense_viewmodel.dart`.
- Auth + profiles: `lib/features/auth/data/repositories/auth_repository_impl.dart` and `lib/features/auth/data/datasources/firestore_user_data_source.dart`.
- Navigation / app shell: `lib/MainScreen.dart` and `lib/features/auth/extra/AuthWrapper.dart`.
- UI building pattern / bottomsheet UX: `lib/features/Expense/presentation/bottomsheet/CreateExpenseCardSheet/create_expense_card_sheet.dart` and other `*/bottomsheet/*` files.
- Food tracking Firestore service: `lib/features/Track/FoodTracking/services/FirebaseFoodService.dart` and viewmodels under `lib/features/Track/FoodTracking/presentation/viewmodel/*`.
- Local tracking storage: `lib/core/services/isar_service.dart` and `lib/features/Track/WaterTracking/data/models/*`.
- Notifications/timezone scheduling: `lib/core/services/notification_service.dart`.

8) Typical agent tasks and shortcuts
- Small feature (UI + Firestore persist): add a ViewModel + Repository, wire it in `lib/main.dart`, then call the repo from a screen/bottomsheet; follow `ExpenseRepository` collection layout under `users/{uid}`.
- Add a new Firestore write/read: follow the transaction pattern in `lib/features/Expense/data/repository/expense_repository.dart` to keep summaries in sync.
- Add a WaterTracking model: create the Isar model under `lib/features/Track/WaterTracking/data/models/*`, add its schema to `core/services/isar_service.dart`, then run build_runner.
- Add new auth flows: register new use cases in `lib/main.dart` and expose them through `lib/features/auth/viewmodel/auth_viewmodel.dart`.

If something is ambiguous, first inspect these files: `lib/main.dart`, `lib/features/Expense/data/repository/expense_repository.dart`, `lib/features/Expense/presentation/viewmodel/expense_viewmodel.dart`, `lib/features/auth/viewmodel/auth_viewmodel.dart`, `lib/MainScreen.dart`.

---
Generated by repository analysis on 2026-04-28. Keep this file minimal and update when structure or persistence changes.
