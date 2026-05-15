import 'package:expense_tracker/core/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/water_goal_entity.dart';

import '../../../domain/usecases/goals/get_goal.dart';
import '../../../domain/usecases/goals/update_goal.dart';

import '../sync/sync_provider.dart';

import 'goal_state.dart';

class GoalNotifier
    extends StateNotifier<GoalState> {

  final Ref ref;
  final AuthService authService;

  final UpdateGoal
  updateGoalUsecase;

  final GetGoal
  getGoalUsecase;

  GoalNotifier({

    required this.ref,

    required this.authService,

    required this.updateGoalUsecase,

    required this.getGoalUsecase,
  }) : super(
    GoalState.initial(),
  );

  final Uuid uuid = const Uuid();

  Future<void> loadGoal()
  async {

    try {

      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final goal =
      await getGoalUsecase();

      if (goal == null) {
        final userId = await authService.getCurrentUserId();
        final defaultGoal = WaterGoalEntity(
          id: uuid.v4(),
          dailyGoalMl: 3000,
          reminderEnabled: true,
          isSynced: false,
          isDeleted: false,
          isEdited: false,
          isActive: true,
          isOfflineCreated: true,
          version: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          userId: userId,
        );

        await updateGoalUsecase(
          defaultGoal,
        );

        state = state.copyWith(
          isLoading: false,
          goal: defaultGoal,
          error: null,
        );

        return;
      }

      state = state.copyWith(
        isLoading: false,
        goal: goal,
        error: null,
      );

    } catch (e) {

      state = state.copyWith(

        isLoading: false,

        error: e.toString(),
      );
    }
  }

  Future<void> updateGoal({

    required int dailyGoalMl,

    required bool reminderEnabled,
  }) async {

    try {

      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final existing = state.goal;
      final userId = existing?.userId ?? await authService.getCurrentUserId();

      final nextVersion = existing == null
          ? 1
          : (existing.version + 1);

      final goal =
      WaterGoalEntity(

        id: existing?.id ?? uuid.v4(),

        dailyGoalMl:
        dailyGoalMl,

        reminderEnabled:
        reminderEnabled,

        isSynced: false,

        isDeleted: false,

        isEdited: existing != null,

        isActive: true,

        isOfflineCreated: existing?.isOfflineCreated ?? true,

        version: nextVersion,

        createdAt: existing?.createdAt ?? DateTime.now(),

        updatedAt: DateTime.now(),

        userId: userId,

        serverId: existing?.serverId,
      );

      await updateGoalUsecase(
        goal,
      );

      await loadGoal();

      ref.read(waterSyncNotifierProvider.notifier).syncNow();

    } catch (e) {

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}