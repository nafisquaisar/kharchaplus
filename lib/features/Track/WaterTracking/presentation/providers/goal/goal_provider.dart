import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/providers/auth_provider.dart';
import '../../../data/datasource/local/isar/water_goal_local_ds.dart';
import '../../../data/datasource/local/isar/water_goal_local_ds_imple.dart';
import '../../../data/datasource/local/isar/water_intake_local_ds_impl.dart';
import '../../../data/datasource/local/isar/water_purchase_local_ds_impl.dart';
import '../../../data/repository/water_repository_impl.dart';

import '../../../domain/usecases/goals/get_goal.dart';
import '../../../domain/usecases/goals/update_goal.dart';

import 'goal_notifier.dart';
import 'goal_state.dart';

// =========================
// Datasource
// =========================

final waterGoalLocalDSProvider = Provider<WaterGoalLocalDataSource>(
  (ref) {
    return WaterGoalLocalDataSourceImpl();
  },
);

// =========================
// Repository
// =========================

final waterGoalRepositoryProvider = Provider<WaterRepositoryImpl>(
  (ref) {
    return WaterRepositoryImpl(
      intakeLocalDataSource: WaterIntakeLocalDataSourceImpl(),
      purchaseLocalDataSource: WaterPurchaseLocalDataSourceImpl(),
      goalLocalDataSource: ref.read(
        waterGoalLocalDSProvider,
      ),
      authService: ref.read(authServiceProvider),
    );
  },
);

// =========================
// Usecases
// =========================

final updateGoalProvider = Provider<UpdateGoal>(
  (ref) {
    return UpdateGoal(
      ref.read(
        waterGoalRepositoryProvider,
      ),
    );
  },
);

final getGoalProvider = Provider<GetGoal>(
  (ref) {
    return GetGoal(
      ref.read(
        waterGoalRepositoryProvider,
      ),
    );
  },
);

// =========================
// Notifier
// =========================

final goalNotifierProvider = StateNotifierProvider<GoalNotifier, GoalState>(
  (ref) {
    return GoalNotifier(
      ref: ref,
      authService: ref.read(authServiceProvider),
      updateGoalUsecase: ref.read(
        updateGoalProvider,
      ),
      getGoalUsecase: ref.read(
        getGoalProvider,
      ),
    );
  },
);
