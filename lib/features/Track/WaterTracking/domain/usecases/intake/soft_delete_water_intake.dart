import '../../repository/water_repository.dart';

class SoftDeleteWaterIntake {

  final WaterRepository repository;

  SoftDeleteWaterIntake(this.repository);

  Future<void> call(
      String id,
      ) async {

    await repository.softDeleteWaterIntake(
      id,
    );
  }
}