import '../../entities/water_intake_entity.dart';
import '../../repository/water_repository.dart';

class GetIntakeByMonth {
  final WaterRepository repository;

  GetIntakeByMonth(this.repository);

  Future<List<WaterIntakeEntity>> call(
    int year,
    int month,
  ) async {
    return repository.getIntakeByMonth(year, month);
  }
}
