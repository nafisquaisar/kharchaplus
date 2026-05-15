import '../../entities/water_intake_entity.dart';
import '../../repository/water_repository.dart';

class GetTodayIntake {

  final WaterRepository repository;

  GetTodayIntake(this.repository);

  Future<List<WaterIntakeEntity>>
  call() async {

    return repository.getTodayIntake();
  }
}