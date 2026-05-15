import '../../../models/water_purchase_model.dart';

abstract class WaterPurchaseLocalDataSource {

  Future<void> addPurchase(
      WaterPurchaseModel model,
      );

  Future<void> updatePurchase(
      WaterPurchaseModel model,
      );

  Future<void> softDeletePurchase(
      String id,
      );

  Future<List<WaterPurchaseModel>>
  getPurchases(
      String userId,
      );

  Future<List<WaterPurchaseModel>>
  getPendingSync();

  Future<WaterPurchaseModel?> getById(String id);

  Future<void> upsertFromRemote(WaterPurchaseModel model);

  Future<void> markSynced(String id, {String? serverId});
}