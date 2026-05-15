import '../../entities/water_goal_entity.dart';
import '../../repository/water_repository.dart';

class GetGoal {

  final WaterRepository repository;
  GetGoal(this.repository);
  Future<WaterGoalEntity?>
  call() async {
    return repository.getGoal();
  }
}
