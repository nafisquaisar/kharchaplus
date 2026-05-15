import '../../entities/water_intake_entity.dart';
import '../../repository/water_repository.dart';

class AddWaterIntake {

  final WaterRepository repository;

  AddWaterIntake(this.repository);

  Future<void> call(
      WaterIntakeEntity intake,
      ) async {

    await repository.addWaterIntake(
      intake,
    );
  }
}