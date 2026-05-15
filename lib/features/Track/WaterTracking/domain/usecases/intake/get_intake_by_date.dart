import '../../entities/water_intake_entity.dart';
import '../../repository/water_repository.dart';

class GetIntakeByDate {
  final WaterRepository repository;

  GetIntakeByDate(this.repository);

  Future<List<WaterIntakeEntity>> call(
    DateTime date,
  ) async {
    return repository.getIntakeByDate(date);
  }
}
