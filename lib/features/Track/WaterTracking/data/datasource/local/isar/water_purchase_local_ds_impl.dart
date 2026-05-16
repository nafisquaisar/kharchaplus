import 'water_purchase_local_ds.dart';
import 'package:isar/isar.dart';

import '../../../../../../../core/services/isar_service.dart';
import '../../../../domain/enum/payment_status.dart';
import '../../../models/water_purchase_model.dart';

class WaterPurchaseLocalDataSourceImpl implements WaterPurchaseLocalDataSource {
  final Isar isar = IsarService.isar;

  @override
  Future<void> addPurchase(
    WaterPurchaseModel model,
  ) async {
    model.paymentStatus = _normalizedPaymentStatus(model.paymentStatus);

    try {
      await isar.writeTxn(() async {
        await isar.waterPurchaseModels.putById(model);
      });
    } on IsarError catch (e) {
      throw WaterPurchaseLocalDataSourceException(
        'Failed to add purchase "${model.id}".',
        cause: e,
      );
    }
  }

  @override
  Future<void> updatePurchase(
    WaterPurchaseModel model,
  ) async {
    final existing = await isar.waterPurchaseModels.getById(model.id);

    if (existing == null) {
      throw WaterPurchaseLocalDataSourceException(
        'Cannot update purchase "${model.id}" because it does not exist locally.',
      );
    }

    existing.type = model.type;
    existing.quantity = model.quantity;
    existing.price = model.price;
    existing.vendor = model.vendor;
    existing.paymentStatus = _normalizedPaymentStatus(model.paymentStatus);
    existing.date = model.date;
    existing.userId = model.userId;
    existing.serverId = model.serverId ?? existing.serverId;

    existing.isSynced = false;
    existing.isEdited = true;
    existing.updatedAt = DateTime.now();
    existing.version = model.version <= existing.version
        ? existing.version + 1
        : model.version;

    try {
      await isar.writeTxn(() async {
        await isar.waterPurchaseModels.put(existing);
      });
    } on IsarError catch (e) {
      throw WaterPurchaseLocalDataSourceException(
        'Failed to update purchase "${model.id}".',
        cause: e,
      );
    }
  }

  @override
  Future<void> softDeletePurchase(
    String id,
  ) async {
    final existing = await isar.waterPurchaseModels.getById(id);

    if (existing == null) return;

    existing.isDeleted = true;

    existing.isSynced = false;

    existing.updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.waterPurchaseModels.put(existing);
    });
  }

  @override
  Future<List<WaterPurchaseModel>> getPurchases(
    String userId,
  ) async {
    return isar.waterPurchaseModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .isDeletedEqualTo(false)
        .findAll();
  }

  @override
  Future<List<WaterPurchaseModel>> getPendingSync() async {
    return isar.waterPurchaseModels.filter().isSyncedEqualTo(false).findAll();
  }

  @override
  Future<WaterPurchaseModel?> getById(String id) async {
    return isar.waterPurchaseModels.getById(id);
  }

  @override
  Future<void> upsertFromRemote(WaterPurchaseModel model) async {
    model.paymentStatus = _normalizedPaymentStatus(model.paymentStatus);

    try {
      await isar.writeTxn(() async {
        await isar.waterPurchaseModels.putById(model);
      });
    } on IsarError catch (e) {
      throw WaterPurchaseLocalDataSourceException(
        'Failed to upsert remote purchase "${model.id}".',
        cause: e,
      );
    }
  }

  @override
  Future<void> markSynced(String id, {String? serverId}) async {
    final existing = await isar.waterPurchaseModels.getById(id);

    if (existing == null) return;

    existing.isSynced = true;
    existing.isEdited = false;
    existing.isOfflineCreated = false;
    if (serverId != null) {
      existing.serverId = serverId;
    }

    await isar.writeTxn(() async {
      await isar.waterPurchaseModels.put(existing);
    });
  }

  String _normalizedPaymentStatus(String? value) {
    return PaymentStatusX.fromValue(value).value;
  }
}

class WaterPurchaseLocalDataSourceException implements Exception {
  final String message;
  final Object? cause;

  const WaterPurchaseLocalDataSourceException(
    this.message, {
    this.cause,
  });

  @override
  String toString() {
    if (cause == null) {
      return 'WaterPurchaseLocalDataSourceException: $message';
    }
    return 'WaterPurchaseLocalDataSourceException: $message Cause: $cause';
  }
}
