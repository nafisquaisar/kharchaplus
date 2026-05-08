# Agents guide — expense_tracker

This file is a concise, actionable guide for AI coding agents working on this Flutter project.

1) Big-picture architecture
- Flutter single-app with feature-first layout: see `lib/features/*` (auth, Home, Expense, Track, Friend, Profile).
- Shared UI and theme pieces are under `lib/core/*` (e.g. `core/Common/CommonAppBar.dart`, `core/Common/CustomBottomNav.dart`, `core/constants/colors.dart`, `core/constants/KharchaThemeColors.dart`).
- Primary persistence uses Firebase/Firestore: repositories under `lib/features/**/data/repository/*` (e.g. `lib/features/Expense/data/repository/expense_repository.dart`) and user profiles stored in `users/{uid}`.
- Entry point: `lib/main.dart` — Firebase is initialized, Firestore persistence is enabled, `MultiProvider` is configured, and `AuthWrapper` is the home screen.

2) Data flows and service boundaries
- UI -> ViewModel (ChangeNotifier) -> Repository -> Firestore. Example: `lib/features/Expense/presentation/viewmodel/expense_viewmodel.dart` calls `ExpenseRepository.addExpense`, which runs a Firestore transaction updating `users/{uid}/expenses`, `expense_cards`, `summary`, and `monthly_summary`.
- Auth flow: `lib/features/auth/viewmodel/auth_viewmodel.dart` -> `AuthRepositoryImpl` -> `FirebaseAuthDataSource` + `FirestoreUserDataSource` (profiles in `users/{uid}`).
- Keys: `ExpenseViewModel.userId` uses `FirebaseAuth.instance.currentUser!.uid`; Firestore collections are nested under `users/{uid}`.

3) Project-specific conventions and patterns
- Feature folder structure: many features use `data/`, `domain/`, `presentation/` (e.g. `lib/features/Expense/`, `lib/features/Profile/`, `lib/features/auth/`).
- UI pattern: ChangeNotifier + Provider with direct reads in screens (see `lib/MainScreen.dart`); local `setState` is still used for UI-only state.
- Bottom sheets are the common create/edit UX surface (look under `*/bottomsheet/*`, e.g. `lib/features/Expense/presentation/bottomsheet/CreateExpenseCardSheet/create_expense_card_sheet.dart`).
- Styling: centralized color and formatter helpers: `lib/core/constants/colors.dart`, `lib/core/constants/KharchaThemeColors.dart`, and `lib/core/utils/formatters.dart`.

4) Integration points & external deps
- Dependencies in `pubspec.yaml`: firebase_core, firebase_auth, cloud_firestore, firebase_app_check, firebase_analytics, firebase_crashlytics, google_sign_in, provider; Hive remains for the legacy model in `lib/data/*`.

5) Developer workflows (commands you must run)
- Get dependencies: `flutter pub get`
- Regenerate Hive adapters after changing the legacy Hive model in `lib/data/model/expense_model.dart`: `flutter pub run build_runner build --delete-conflicting-outputs` (typeId must be stable).
- Run app: `flutter run -d <deviceId>` or use IDE run configurations. Example for Windows: `flutter run -d windows`.
- Run analyzer/tests: `flutter analyze` and `flutter test`.
- Build release APK: `flutter build apk`; Android bundle: `flutter build appbundle`.

6) Safety notes / gotchas for agents
- Hive TypeId stability: `@HiveType(typeId: 0)` in `lib/data/model/expense_model.dart` — do NOT reuse/change existing typeIds without migration steps; this model is legacy and not wired into the main flow.
- Auth guard: `ExpenseViewModel.userId` assumes `FirebaseAuth.instance.currentUser` is non-null; only call expense flows once authenticated (see `lib/features/auth/extra/AuthWrapper.dart`).
- Provider wiring: providers are configured in `lib/main.dart`; add new repositories/use cases/viewmodels to `MultiProvider` there.

7) Where to look for examples
- Persisting items: `lib/features/Expense/data/repository/expense_repository.dart` and `lib/features/Expense/presentation/viewmodel/expense_viewmodel.dart`.
- Auth + profiles: `lib/features/auth/data/repositories/auth_repository_impl.dart` and `lib/features/auth/data/datasources/firestore_user_data_source.dart`.
- Navigation / app shell: `lib/MainScreen.dart` and `lib/features/auth/extra/AuthWrapper.dart`.
- UI building pattern / bottomsheet UX: `lib/features/Expense/presentation/bottomsheet/CreateExpenseCardSheet/create_expense_card_sheet.dart` and other `*/bottomsheet/*` files.

8) Typical agent tasks and shortcuts
- Small feature (UI + Firestore persist): add a ViewModel + Repository, wire it in `lib/main.dart`, then call the repo from a screen/bottomsheet; follow `ExpenseRepository` collection layout under `users/{uid}`.
- Add a new Firestore write/read: follow the transaction pattern in `lib/features/Expense/data/repository/expense_repository.dart` to keep summaries in sync.
- Add new auth flows: register new use cases in `lib/main.dart` and expose them through `lib/features/auth/viewmodel/auth_viewmodel.dart`.

If something is ambiguous, first inspect these files: `lib/main.dart`, `lib/features/Expense/data/repository/expense_repository.dart`, `lib/features/Expense/presentation/viewmodel/expense_viewmodel.dart`, `lib/features/auth/viewmodel/auth_viewmodel.dart`, `lib/MainScreen.dart`.

---
Generated by repository analysis on 2026-04-28. Keep this file minimal and update when structure or persistence changes.
