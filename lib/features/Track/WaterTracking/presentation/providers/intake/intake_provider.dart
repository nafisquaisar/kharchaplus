import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/providers/auth_provider.dart';
import '../../../data/datasource/local/isar/water_intake_local_ds.dart';
import '../../../data/datasource/local/isar/water_intake_local_ds_impl.dart';
import '../../../data/datasource/local/isar/water_purchase_local_ds_impl.dart';
import '../../../data/datasource/local/isar/water_goal_local_ds_imple.dart';


import '../../../data/repository/water_repository_impl.dart';

import '../../../domain/usecases/intake/add_water_intake.dart';
import '../../../domain/usecases/intake/get_today_intake.dart';
import '../../../domain/usecases/intake/get_weekly_intake.dart';
import '../../../domain/usecases/intake/get_monthly_intake.dart';

import 'intake_notifier.dart';
import 'intake_state.dart';

// =========================
// Datasource
// =========================

final waterIntakeLocalDSProvider =
Provider<
    WaterIntakeLocalDataSource>(

      (ref) {

    return
      WaterIntakeLocalDataSourceImpl();
  },
);

// =========================
// Repository
// =========================

final waterRepositoryProvider =
Provider<WaterRepositoryImpl>(

      (ref) {

    return WaterRepositoryImpl(

      intakeLocalDataSource:
      ref.read(
        waterIntakeLocalDSProvider,
      ),

      purchaseLocalDataSource:
      WaterPurchaseLocalDataSourceImpl(),

      goalLocalDataSource:
      WaterGoalLocalDataSourceImpl(),

      authService: ref.read(authServiceProvider),
    );
  },
);

// =========================
// Usecases
// =========================

final addWaterIntakeProvider =
Provider<AddWaterIntake>(

      (ref) {

    return AddWaterIntake(

      ref.read(
        waterRepositoryProvider,
      ),
    );
  },
);

final getTodayIntakeProvider =
Provider<GetTodayIntake>(

      (ref) {

    return GetTodayIntake(

      ref.read(
        waterRepositoryProvider,
      ),
    );
  },
);

final getWeeklyIntakeProvider =
Provider<GetWeeklyIntake>(

      (ref) {

    return GetWeeklyIntake(

      ref.read(
        waterRepositoryProvider,
      ),
    );
  },
);

final getMonthlyIntakeProvider =
Provider<GetMonthlyIntake>(

      (ref) {

    return GetMonthlyIntake(

      ref.read(
        waterRepositoryProvider,
      ),
    );
  },
);

// =========================
// Notifier
// =========================

final intakeNotifierProvider =
StateNotifierProvider<
    IntakeNotifier,
    IntakeState>(

      (ref) {

    return IntakeNotifier(

      ref: ref,

      authService: ref.read(authServiceProvider),

      addWaterIntakeUsecase:
      ref.read(
        addWaterIntakeProvider,
      ),

      getTodayIntakeUsecase:
      ref.read(
        getTodayIntakeProvider,
      ),

      getWeeklyIntakeUsecase:
      ref.read(
        getWeeklyIntakeProvider,
      ),

      getMonthlyIntakeUsecase:
      ref.read(
        getMonthlyIntakeProvider,
      ),
    );
  },
);