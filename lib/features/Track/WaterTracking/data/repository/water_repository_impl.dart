import '../../../../../core/base/base_entity.dart';
import '../../../../../core/services/auth_service.dart';

import '../../domain/entities/water_goal_entity.dart';
import '../../domain/entities/water_intake_entity.dart';
import '../../domain/entities/water_purchase_entity.dart';

import '../../domain/repository/water_repository.dart';

import '../datasource/local/isar/water_goal_local_ds.dart';
import '../datasource/local/isar/water_intake_local_ds.dart';
import '../datasource/local/isar/water_purchase_local_ds.dart';

import '../mapper/water_mapper.dart';

class WaterRepositoryImpl implements WaterRepository {
  final WaterIntakeLocalDataSource intakeLocalDataSource;
  final WaterPurchaseLocalDataSource purchaseLocalDataSource;
  final WaterGoalLocalDataSource goalLocalDataSource;
  final AuthService authService;

  WaterRepositoryImpl({
    required this.intakeLocalDataSource,
    required this.purchaseLocalDataSource,
    required this.goalLocalDataSource,
    required this.authService,
  });

  // =========================
  // Intake
  // =========================

  @override
  Future<void> addWaterIntake(
    WaterIntakeEntity intake,
  ) async {
    final model = WaterMapper.intakeEntityToModel(
      intake,
    );

    await intakeLocalDataSource.addWaterIntake(model);
  }

  @override
  Future<void> updateWaterIntake(
    WaterIntakeEntity intake,
  ) async {
    final model = WaterMapper.intakeEntityToModel(
      intake,
    );

    await intakeLocalDataSource.updateWaterIntake(model);
  }

  @override
  Future<void> softDeleteWaterIntake(
    String id,
  ) async {
    await intakeLocalDataSource.softDeleteWaterIntake(id);
  }

  @override
  Future<List<WaterIntakeEntity>> getTodayIntake() async {
    final now = DateTime.now();
    return getIntakeByDate(
      DateTime(
        now.year,
        now.month,
        now.day,
      ),
    );
  }

  @override
  Future<List<WaterIntakeEntity>> getWeeklyIntake() async {
    return getIntakeByWeek(
      DateTime.now(),
    );
  }

  @override
  Future<List<WaterIntakeEntity>> getMonthlyIntake() async {
    final now = DateTime.now();
    return getIntakeByMonth(
      now.year,
      now.month,
    );
  }

  @override
  Future<List<WaterIntakeEntity>> getIntakeByDate(
    DateTime date,
  ) async {
    final userId = await authService.getCurrentUserId();

    final models = await intakeLocalDataSource.getIntakeByDate(
      userId,
      date,
    );

    return models
        .map(
          WaterMapper.intakeModelToEntity,
        )
        .toList();
  }

  @override
  Future<List<WaterIntakeEntity>> getIntakeByWeek(
    DateTime weekAnchor,
  ) async {
    final userId = await authService.getCurrentUserId();

    final models = await intakeLocalDataSource.getIntakeByWeek(
      userId,
      weekAnchor,
    );

    return models
        .map(
          WaterMapper.intakeModelToEntity,
        )
        .toList();
  }

  @override
  Future<List<WaterIntakeEntity>> getIntakeByMonth(
    int year,
    int month,
  ) async {
    final userId = await authService.getCurrentUserId();

    final models = await intakeLocalDataSource.getIntakeByMonth(
      userId,
      year,
      month,
    );

    return models
        .map(
          WaterMapper.intakeModelToEntity,
        )
        .toList();
  }

  // =========================
  // Purchase
  // =========================

  @override
  Future<void> addPurchase(
    WaterPurchaseEntity purchase,
  ) async {
    final model = WaterMapper.purchaseEntityToModel(
      purchase,
    );

    await purchaseLocalDataSource.addPurchase(model);
  }

  @override
  Future<void> updatePurchase(
    WaterPurchaseEntity purchase,
  ) async {
    final model = WaterMapper.purchaseEntityToModel(
      purchase,
    );

    await purchaseLocalDataSource.updatePurchase(model);
  }

  @override
  Future<void> softDeletePurchase(
    String id,
  ) async {
    await purchaseLocalDataSource.softDeletePurchase(id);
  }

  @override
  Future<List<WaterPurchaseEntity>> getPurchases() async {
    final userId = await authService.getCurrentUserId();

    final models = await purchaseLocalDataSource.getPurchases(
      userId,
    );

    return models
        .map(
          WaterMapper.purchaseModelToEntity,
        )
        .toList();
  }

  // =========================
  // Goal
  // =========================

  @override
  Future<void> updateGoal(
    WaterGoalEntity goal,
  ) async {
    final model = WaterMapper.goalEntityToModel(
      goal,
    );

    await goalLocalDataSource.updateGoal(model);
  }

  @override
  Future<WaterGoalEntity?> getGoal() async {
    final userId = await authService.getCurrentUserId();

    final model = await goalLocalDataSource.getGoal(
      userId,
    );

    if (model == null) {
      return null;
    }

    return WaterMapper.goalModelToEntity(
      model,
    );
  }

  // =========================
  // Sync
  // =========================

  @override
  Future<List<BaseEntity>> getPendingSync() async {
    final intakeModels = await intakeLocalDataSource.getPendingSync();

    final purchaseModels = await purchaseLocalDataSource.getPendingSync();

    final intakeEntities = intakeModels
        .map(
          WaterMapper.intakeModelToEntity,
        )
        .toList();

    final purchaseEntities = purchaseModels
        .map(
          WaterMapper.purchaseModelToEntity,
        )
        .toList();

    return [
      ...intakeEntities,
      ...purchaseEntities,
    ];
  }

  @override
  Future<void> markAsSynced(
    String id,
  ) async {
    // Firebase sync phase
  }
}
