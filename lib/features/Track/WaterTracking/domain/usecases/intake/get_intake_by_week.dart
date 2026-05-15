import '../../entities/water_intake_entity.dart';
import '../../repository/water_repository.dart';

class GetIntakeByWeek {
  final WaterRepository repository;

  GetIntakeByWeek(this.repository);

  Future<List<WaterIntakeEntity>> call(
    DateTime weekAnchor,
  ) async {
    return repository.getIntakeByWeek(weekAnchor);
  }
}
