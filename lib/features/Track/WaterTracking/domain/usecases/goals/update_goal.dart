import '../../entities/water_goal_entity.dart';
import '../../repository/water_repository.dart';

class UpdateGoal {

  final WaterRepository repository;

  UpdateGoal(this.repository);

  Future<void> call(
      WaterGoalEntity goal,
      ) async {

    await repository.updateGoal(
      goal,
    );
  }
}