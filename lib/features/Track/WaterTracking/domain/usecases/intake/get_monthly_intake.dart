import '../../entities/water_intake_entity.dart';
import '../../repository/water_repository.dart';

class GetMonthlyIntake {
  final WaterRepository repository;

  GetMonthlyIntake(this.repository);

  Future<List<WaterIntakeEntity>> call() async {
    return repository.getMonthlyIntake();
  }
}

