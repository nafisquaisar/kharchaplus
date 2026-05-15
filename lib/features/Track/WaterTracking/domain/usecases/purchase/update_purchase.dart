import '../../entities/water_purchase_entity.dart';
import '../../repository/water_repository.dart';

class UpdatePurchase {

  final WaterRepository repository;

  UpdatePurchase(this.repository);

  Future<void> call(
      WaterPurchaseEntity purchase,
      ) async {

    await repository.updatePurchase(
      purchase,
    );
  }
}