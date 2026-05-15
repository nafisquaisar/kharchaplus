import '../../entities/water_intake_entity.dart';
import '../../repository/water_repository.dart';

class UpdateWaterIntake {

  final WaterRepository repository;

  UpdateWaterIntake(this.repository);

  Future<void> call(
      WaterIntakeEntity intake,
      ) async {

    await repository.updateWaterIntake(
      intake,
    );
  }
}