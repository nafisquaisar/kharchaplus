import 'package:expense_tracker/core/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/water_intake_entity.dart';

import '../../../domain/usecases/intake/add_water_intake.dart';
import '../../../domain/usecases/intake/get_today_intake.dart';
import '../../../domain/usecases/intake/get_weekly_intake.dart';
import '../../../domain/usecases/intake/get_monthly_intake.dart';

import '../sync/sync_provider.dart';

import 'intake_state.dart';

class IntakeNotifier extends StateNotifier<IntakeState> {
  final Ref ref;
  final AuthService authService;

  final AddWaterIntake addWaterIntakeUsecase;

  final GetTodayIntake getTodayIntakeUsecase;

  final GetWeeklyIntake getWeeklyIntakeUsecase;

  final GetMonthlyIntake getMonthlyIntakeUsecase;

  IntakeNotifier({
    required this.ref,
    required this.authService,
    required this.addWaterIntakeUsecase,
    required this.getTodayIntakeUsecase,
    required this.getWeeklyIntakeUsecase,
    required this.getMonthlyIntakeUsecase,
  }) : super(
          IntakeState.initial(),
        );

  final Uuid uuid = const Uuid();

  Future<void> loadTodayIntake() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final data = await getTodayIntakeUsecase();

      state = state.copyWith(
        isLoading: false,
        todayIntake: data,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadWeeklyIntake() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final data = await getWeeklyIntakeUsecase();

      state = state.copyWith(
        isLoading: false,
        weeklyIntake: data,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMonthlyIntake() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final data = await getMonthlyIntakeUsecase();

      state = state.copyWith(
        isLoading: false,
        monthlyIntake: data,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addIntake(
    int amountMl, {
    DateTime? dateTime,
    String sourceType = 'Manual',
  }) async {
    try {
      final userId = await authService.getCurrentUserId();

      final intake = WaterIntakeEntity(
        id: uuid.v4(),
        amountMl: amountMl,
        dateTime: dateTime ?? DateTime.now(),
        sourceType: sourceType,
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

      state = state.copyWith(
        todayIntake: [
          ...state.todayIntake,
          intake,
        ],
        weeklyIntake: [
          ...state.weeklyIntake,
          intake,
        ],
        monthlyIntake: [
          ...state.monthlyIntake,
          intake,
        ],
        error: null,
      );

      await addWaterIntakeUsecase(
        intake,
      );

      await loadTodayIntake();

      await loadWeeklyIntake();

      await loadMonthlyIntake();

      ref.read(waterSyncNotifierProvider.notifier).syncNow();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
