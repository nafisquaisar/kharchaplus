import '../../entities/water_purchase_entity.dart';
import '../../repository/water_repository.dart';

class GetPurchases {

  final WaterRepository repository;

  GetPurchases(this.repository);

  Future<List<WaterPurchaseEntity>>
  call() async {

    return repository.getPurchases();
  }
}