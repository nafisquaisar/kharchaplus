import '../../repository/water_repository.dart';

class SoftDeletePurchase {

  final WaterRepository repository;

  SoftDeletePurchase(this.repository);

  Future<void> call(
      String id,
      ) async {

    await repository.softDeletePurchase(
      id,
    );
  }
}