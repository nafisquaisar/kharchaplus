import 'package:isar/isar.dart';

import '../../domain/entities/water_tracking_entity.dart';

part 'water_tracking_model.g.dart';

@collection
class WaterTrackingHomeModel extends WaterTrackingHomeEntity {
  Id isarId = Isar.autoIncrement;

  WaterTrackingHomeModel({
    required super.id,
    required super.todayIntakeMl,
    required super.dailyGoalMl,
    required super.intakePercent,
    required super.monthlyExpense,
    required super.previousMonthExpense,
    required super.expensePercentChange,
    required super.expenseTrend,
    required super.updatedAt,
  });

  factory WaterTrackingHomeModel.fromEntity(
    WaterTrackingHomeEntity entity,
  ) {
    return WaterTrackingHomeModel(
      id: entity.id,
      todayIntakeMl: entity.todayIntakeMl,
      dailyGoalMl: entity.dailyGoalMl,
      intakePercent: entity.intakePercent,
      monthlyExpense: entity.monthlyExpense,
      previousMonthExpense: entity.previousMonthExpense,
      expensePercentChange: entity.expensePercentChange,
      expenseTrend: entity.expenseTrend,
      updatedAt: entity.updatedAt,
    );
  }
}
