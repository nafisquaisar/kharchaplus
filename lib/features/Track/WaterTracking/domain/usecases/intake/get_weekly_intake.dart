import '../../entities/water_intake_entity.dart';
import '../../repository/water_repository.dart';

class GetWeeklyIntake {

  final WaterRepository repository;

  GetWeeklyIntake(this.repository);

  Future<List<WaterIntakeEntity>>
  call() async {

    return repository.getWeeklyIntake();
  }
}