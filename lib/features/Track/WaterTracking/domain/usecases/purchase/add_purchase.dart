import '../../entities/water_purchase_entity.dart';
import '../../repository/water_repository.dart';

class AddPurchase {

  final WaterRepository repository;

  AddPurchase(this.repository);

  Future<void> call(
      WaterPurchaseEntity purchase,
      ) async {

    await repository.addPurchase(
      purchase,
    );
  }
}